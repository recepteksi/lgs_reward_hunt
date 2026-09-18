import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/domain/points/rules/points_rules.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_repeat_enum.dart';
import 'package:lgs_reward_hunt/domain/task/rules/task_plan_rules.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_handler_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_request.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_response.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_route.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_store.dart';

/// The parent's recurring task plan, the standard plan it starts from, and the
/// fortnight it writes.
///
/// Saving a plan replaces it and rewrites the household's future: every
/// child's unfinished tasks from today on are dropped and
/// `TaskPlanRules.horizonDays` of tasks are written from the plan, on the days
/// `TaskRepeatEnum.occursOn` picks — the same rule the setup summary counts
/// with. A completed task is never touched; it has been paid for.
///
/// [writeFortnight] is public because the demo household is seeded the same
/// way a parent's saved plan is — one rule for writing a fortnight.
final class MockTaskPlanHandler implements MockHandlerInterface {
  const MockTaskPlanHandler(this._store, this._clock);

  final MockStore _store;

  final DateTime Function() _clock;

  @override
  List<MockRoute> get routes => <MockRoute>[
    MockRoute(
      'GET',
      RegExp(r'^/task-plans/standard$'),
      (_) => MockResponse.ok(_store.standardTaskPlan),
    ),
    MockRoute('GET', RegExp(r'^/parents/([^/]+)/task-plan$'), _planOf),
    MockRoute('PUT', RegExp(r'^/parents/([^/]+)/task-plan$'), _savePlan),
  ];

  MockResponse _planOf(MockRequest request) => MockResponse.ok(
    _store.taskPlans[request.id] ?? const <Map<String, Object?>>[],
  );

  MockResponse _savePlan(MockRequest request) {
    final parentId = request.id;
    if (_store.findById(_store.parents, parentId) == null) {
      return MockResponse.fail(404, FailureMessageKey.unauthorized);
    }

    final rows =
        (request.body['templates'] as List<Object?>? ?? const <Object?>[])
            .map((Object? row) => Map<String, Object?>.from(row! as Map))
            .toList();
    if (rows.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.taskPlanEmpty);
    }

    final stored = <Map<String, Object?>>[];
    for (final row in rows) {
      final refusal = _refusalOf(row);
      if (refusal != null) return refusal;

      stored.add(<String, Object?>{
        ...row,
        'id': row['id'] ?? _store.nextId('template'),
        'topic': (row['topic']! as String).trim(),
      });
    }
    _store.taskPlans[parentId] = stored;

    writeFortnight(parentId, stored);
    return MockResponse.ok(stored);
  }

  MockResponse? _refusalOf(Map<String, Object?> row) {
    final topic = (row['topic'] as String? ?? CharConstants.empty).trim();
    if (topic.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.taskTitleEmpty);
    }

    final category = TaskCategoryEnum.fromName(row['category'] as String?);
    if (category == null || category.kind.name != row['kind']) {
      return MockResponse.fail(422, FailureMessageKey.taskCategoryInvalid);
    }
    if (TaskRepeatEnum.fromName(row['repeat'] as String?) == null) {
      return MockResponse.fail(422, FailureMessageKey.unexpectedResponse);
    }

    final points = row['points'] as int? ?? 0;
    if (points < PointsRules.minTaskPoints ||
        points > PointsRules.maxTaskPoints) {
      return MockResponse.fail(422, FailureMessageKey.taskPointsInvalid);
    }

    final minutes = row['durationMinutes'] as int? ?? 0;
    if (minutes < PointsRules.minTaskMinutes ||
        minutes > PointsRules.maxTaskMinutes) {
      return MockResponse.fail(422, FailureMessageKey.taskDurationInvalid);
    }

    final start = row['startMinute'] as int? ?? -1;
    if (start < 0 || start >= TaskPlanRules.minutesPerDay) {
      return MockResponse.fail(422, FailureMessageKey.taskTimeInvalid);
    }
    return null;
  }

  void writeFortnight(String parentId, List<Map<String, Object?>> plan) {
    final now = _clock();
    final today = DateTime(now.year, now.month, now.day);
    final childIds = _store.childIdsOf(parentId);

    _store.tasks.removeWhere(
      (Map<String, Object?> task) =>
          childIds.contains(task['childId']) &&
          task['completedAt'] == null &&
          !DateTime.parse(task['scheduledAt']! as String).isBefore(today),
    );

    for (final childId in childIds) {
      for (int offset = 0; offset < TaskPlanRules.horizonDays; offset++) {
        final day = DateTime(today.year, today.month, today.day + offset);
        for (final template in plan) {
          final repeat = TaskRepeatEnum.fromName(
            template['repeat'] as String?,
          )!;
          if (!repeat.occursOn(day, from: today)) continue;

          _store.tasks.add(<String, Object?>{
            'id': _store.nextId('task'),
            'childId': childId,
            'title': template['topic'],
            'category': template['category'],
            'scheduledAt': day
                .add(Duration(minutes: template['startMinute']! as int))
                .toIso8601String(),
            'durationMinutes': template['durationMinutes'],
            'points': template['points'],
            'completedAt': null,
          });
        }
      }
    }
  }
}
