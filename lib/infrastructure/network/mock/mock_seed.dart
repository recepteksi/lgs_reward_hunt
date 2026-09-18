import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:lgs_reward_hunt/domain/points/enums/points_reason_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/redemption_status_enum.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_store.dart';
import 'package:lgs_reward_hunt/infrastructure/task/mock/mock_task_plan_handler.dart';

/// Fills the mock backend from `assets/mock/`.
///
/// Two kinds of data, loaded separately. [loadCatalog] is what the backend
/// always serves — the avatar catalogue, the suggested task plan and reward
/// pool — so it runs on every start, including a test's. [loadDemoHousehold]
/// is the family the app opens on when there is no backend: an empty store
/// shows an empty home page, which tells nobody whether the product works, so
/// it seeds a week of history — earned points, a request still waiting on a
/// parent — then saves the standard plan (plus a weekend practice exam) for the
/// fortnight ahead, the way a parent's own plan is written, and ticks the first
/// of today's tasks.
///
/// The files hold data only. The dates are made here, relative to `now`,
/// because a file of timestamps is stale the day after it is written and a
/// countdown app that opens on last week's tasks looks broken. The demo
/// account (email, password, PIN) is whatever `demo_household.json` says.
///
/// `bundle` is the asset bundle to read from, `rootBundle` unless a test hands
/// in another.
abstract final class MockSeed {
  static const String _avatars = 'assets/mock/avatars.json';

  static const String _standardTaskPlan = 'assets/mock/standard_task_plan.json';

  static const String _standardRewardPool =
      'assets/mock/standard_reward_pool.json';

  static const String _demoHousehold = 'assets/mock/demo_household.json';

  static Future<void> loadCatalog(
    MockStore store, {
    AssetBundle? bundle,
  }) async {
    final AssetBundle source = bundle ?? rootBundle;

    store.avatars.addAll(await _rows(source, _avatars));
    for (final row in await _rows(source, _standardTaskPlan)) {
      store.standardTaskPlan.add(<String, Object?>{
        'id': store.nextId('standard'),
        ...row,
      });
    }
    for (final row in await _rows(source, _standardRewardPool)) {
      store.standardRewardPool.add(<String, Object?>{
        'id': store.nextId('standard'),
        ...row,
      });
    }
  }

  static Future<void> loadDemoHousehold(
    MockStore store, {
    required DateTime now,
    AssetBundle? bundle,
  }) async {
    final demo = Map<String, Object?>.from(
      jsonDecode(await (bundle ?? rootBundle).loadString(_demoHousehold))
          as Map,
    );

    final parent = Map<String, Object?>.from(demo['parent']! as Map);
    store.parents.add(<String, Object?>{
      ...parent,
      'usedLinkCodes': <String>[],
    });

    final child = Map<String, Object?>.from(demo['child']! as Map);
    final childId = child['id']! as String;
    store.children.add(<String, Object?>{...child, 'parentId': parent['id']});

    for (final Object? reward in demo['rewards']! as List<Object?>) {
      store.rewards.add(<String, Object?>{
        'id': store.nextId('reward'),
        'parentId': parent['id'],
        ...Map<String, Object?>.from(reward! as Map),
        'isActive': true,
      });
    }

    final today = DateTime(now.year, now.month, now.day);
    final dailyTasks = (demo['dailyTasks']! as List<Object?>)
        .map((Object? row) => Map<String, Object?>.from(row! as Map))
        .toList();
    final minutesToFinish = demo['minutesToFinishTask']! as int;
    final historyDays = demo['historyDays']! as int;

    for (int daysAgo = historyDays; daysAgo >= 1; daysAgo -= 1) {
      _seedDay(
        store,
        childId: childId,
        day: today.subtract(Duration(days: daysAgo)),
        tasks: dailyTasks,
        minutesToFinish: minutesToFinish,
        completeAll: daysAgo.isEven,
      );
    }

    final parentId = parent['id']! as String;
    final plan = <Map<String, Object?>>[
      for (final line in store.standardTaskPlan)
        <String, Object?>{...line, 'id': store.nextId('template')},
      for (final Object? line in demo['extraPlanLines']! as List<Object?>)
        <String, Object?>{
          ...Map<String, Object?>.from(line! as Map),
          'id': store.nextId('template'),
        },
    ];
    store.taskPlans[parentId] = plan;
    MockTaskPlanHandler(store, () => now).writeFortnight(parentId, plan);
    _completeToday(
      store,
      childId: childId,
      today: today,
      count: demo['completedToday']! as int,
      at: now,
    );

    final pending = Map<String, Object?>.from(demo['pendingRequest']! as Map);
    final held = store.rewards[pending['rewardIndex']! as int];
    final requestedAt = now.subtract(
      Duration(hours: pending['hoursAgo']! as int),
    );
    store.redemptions.add(<String, Object?>{
      'id': store.nextId('redemption'),
      'childId': childId,
      'rewardId': held['id'],
      'rewardName': held['name'],
      'costAtRequest': held['cost'],
      'status': RedemptionStatusEnum.pending.name,
      'requestedAt': requestedAt.toIso8601String(),
      'decidedAt': null,
      'parentNote': null,
    });
    store.addLedger(
      childId: childId,
      amount: -(held['cost']! as int),
      reason: PointsReasonEnum.redemptionHeld.name,
      reference: store.redemptions.last['id']! as String,
      at: requestedAt,
    );
  }

  static void _completeToday(
    MockStore store, {
    required String childId,
    required DateTime today,
    required int count,
    required DateTime at,
  }) {
    final todays =
        store.tasks
            .where(
              (Map<String, Object?> task) =>
                  task['childId'] == childId &&
                  MockStore.sameDay(
                    DateTime.parse(task['scheduledAt']! as String),
                    today,
                  ),
            )
            .toList()
          ..sort(
            (Map<String, Object?> a, Map<String, Object?> b) =>
                (a['scheduledAt']! as String).compareTo(
                  b['scheduledAt']! as String,
                ),
          );

    for (final task in todays.take(count)) {
      task['completedAt'] = at.toIso8601String();
      store.addLedger(
        childId: childId,
        amount: task['points']! as int,
        reason: PointsReasonEnum.taskCompleted.name,
        reference: task['id']! as String,
        at: at,
      );
    }
  }

  static Future<List<Map<String, Object?>>> _rows(
    AssetBundle bundle,
    String path,
  ) async => (jsonDecode(await bundle.loadString(path)) as List<Object?>)
      .map((Object? row) => Map<String, Object?>.from(row! as Map))
      .toList();

  static void _seedDay(
    MockStore store, {
    required String childId,
    required DateTime day,
    required List<Map<String, Object?>> tasks,
    required int minutesToFinish,
    required bool completeAll,
  }) {
    for (int i = 0; i < tasks.length; i += 1) {
      final row = tasks[i];
      final scheduledAt = DateTime(
        day.year,
        day.month,
        day.day,
        row['hour']! as int,
      );
      final finishedAt = scheduledAt.add(Duration(minutes: minutesToFinish));
      final done = completeAll || i == tasks.length - 1;
      final taskId = store.nextId('task');

      store.tasks.add(<String, Object?>{
        'id': taskId,
        'childId': childId,
        'title': row['title'],
        'category': row['category'],
        'scheduledAt': scheduledAt.toIso8601String(),
        'durationMinutes': row['durationMinutes'],
        'points': row['points'],
        'completedAt': done ? finishedAt.toIso8601String() : null,
      });

      if (done) {
        store.addLedger(
          childId: childId,
          amount: row['points']! as int,
          reason: PointsReasonEnum.taskCompleted.name,
          reference: taskId,
          at: finishedAt,
        );
      }
    }
  }
}
