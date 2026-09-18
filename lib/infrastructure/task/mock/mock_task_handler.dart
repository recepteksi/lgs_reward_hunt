import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/domain/points/enums/points_reason_enum.dart';
import 'package:lgs_reward_hunt/domain/points/rules/points_rules.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_repeat_enum.dart';
import 'package:lgs_reward_hunt/domain/task/rules/task_plan_rules.dart';
import 'package:lgs_reward_hunt/infrastructure/network/api_paths.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_handler_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_request.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_response.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_route.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_store.dart';

/// A child's days: the tasks of one day or of a range (`from`…`to`, both
/// days included), adding one, completing one — and the parent's edits: a
/// series written on the days its repeat falls on, and changing or removing
/// an unfinished task. A finished task is never changed or removed; its points
/// are paid.
///
/// A task pays out **once**, and only on its own calendar day. Paying twice is
/// how a ledger stops balancing; paying late is how a plan stops meaning
/// anything. Finishing every task scheduled for a day — at least
/// `PointsRules.minTasksForDayBonus` of them — pays
/// `PointsRules.dayCompletionBonus` on top: the last task of the day has to be
/// worth more than the first or there is no reason to finish.
///
/// [_clock] is the backend's "now", injected so a test can stand on any day.
final class MockTaskHandler implements MockHandlerInterface {
  const MockTaskHandler(this._store, this._clock);

  final MockStore _store;

  final DateTime Function() _clock;

  @override
  List<MockRoute> get routes => <MockRoute>[
    MockRoute('GET', RegExp(r'^/children/([^/]+)/tasks$'), _tasksForDay),
    MockRoute('POST', RegExp(r'^/children/([^/]+)/tasks$'), _createTask),
    MockRoute('POST', RegExp(r'^/tasks/([^/]+)/complete$'), _completeTask),
    MockRoute('POST', RegExp(r'^/children/([^/]+)/tasks/series$'), _addSeries),
    MockRoute('PUT', RegExp(r'^/tasks/([^/]+)$'), _updateTask),
    MockRoute('DELETE', RegExp(r'^/tasks/([^/]+)$'), _deleteTask),
  ];

  MockResponse _tasksForDay(MockRequest request) {
    final from = request.query[ApiPaths.fromQuery] as String?;
    final to = request.query[ApiPaths.toQuery] as String?;
    if (from != null && to != null) {
      return _tasksBetween(
        request.id,
        DateTime.parse(from),
        DateTime.parse(to),
      );
    }

    final raw = request.query[ApiPaths.dayQuery] as String?;
    final day = raw == null ? _clock() : DateTime.parse(raw);

    return MockResponse.ok(
      _store.tasks
          .where(
            (Map<String, Object?> task) =>
                task['childId'] == request.id &&
                MockStore.sameDay(
                  DateTime.parse(task['scheduledAt']! as String),
                  day,
                ),
          )
          .toList(),
    );
  }

  MockResponse _tasksBetween(String childId, DateTime from, DateTime to) {
    final DateTime end = DateTime(to.year, to.month, to.day + 1);
    return MockResponse.ok(
      _store.tasks.where((Map<String, Object?> task) {
        if (task['childId'] != childId) return false;
        final scheduledAt = DateTime.parse(task['scheduledAt']! as String);
        return !scheduledAt.isBefore(from) && scheduledAt.isBefore(end);
      }).toList(),
    );
  }

  MockResponse _createTask(MockRequest request) {
    final body = request.body;
    final title = (body['title'] as String? ?? CharConstants.empty).trim();
    if (title.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.taskTitleEmpty);
    }

    final points = body['points'] as int? ?? 0;
    if (points < PointsRules.minTaskPoints ||
        points > PointsRules.maxTaskPoints) {
      return MockResponse.fail(422, FailureMessageKey.taskPointsInvalid);
    }

    final minutes = body['durationMinutes'] as int? ?? 0;
    if (minutes < PointsRules.minTaskMinutes ||
        minutes > PointsRules.maxTaskMinutes) {
      return MockResponse.fail(422, FailureMessageKey.taskDurationInvalid);
    }

    final row = <String, Object?>{
      'id': _store.nextId('task'),
      'childId': request.id,
      'title': title,
      'category': body['category'],
      'scheduledAt': body['scheduledAt'],
      'durationMinutes': minutes,
      'points': points,
      'completedAt': null,
    };
    _store.tasks.add(row);
    return MockResponse.created(row);
  }

  MockResponse _completeTask(MockRequest request) {
    final taskId = request.id;
    final task = _store.findById(_store.tasks, taskId);
    if (task == null) {
      return MockResponse.fail(404, FailureMessageKey.unexpectedResponse);
    }
    if (task['completedAt'] != null) {
      return MockResponse.fail(409, FailureMessageKey.taskAlreadyCompleted);
    }

    final now = _clock();
    final scheduledAt = DateTime.parse(task['scheduledAt']! as String);
    if (!MockStore.sameDay(scheduledAt, now)) {
      return MockResponse.fail(409, FailureMessageKey.taskNotToday);
    }

    task['completedAt'] = now.toIso8601String();
    final childId = task['childId']! as String;
    _store.addLedger(
      childId: childId,
      amount: task['points']! as int,
      reason: PointsReasonEnum.taskCompleted.name,
      reference: taskId,
      at: now,
    );

    final ofDay = _store.tasks
        .where(
          (Map<String, Object?> t) =>
              t['childId'] == childId &&
              MockStore.sameDay(
                DateTime.parse(t['scheduledAt']! as String),
                scheduledAt,
              ),
        )
        .toList();
    if (ofDay.length >= PointsRules.minTasksForDayBonus &&
        ofDay.every((Map<String, Object?> t) => t['completedAt'] != null)) {
      _store.addLedger(
        childId: childId,
        amount: PointsRules.dayCompletionBonus,
        reason: PointsReasonEnum.dayCompletionBonus.name,
        reference: _dayKey(scheduledAt),
        at: now,
      );
    }

    return MockResponse.ok(task);
  }

  MockResponse _addSeries(MockRequest request) {
    final body = request.body;
    final topic = (body['topic'] as String? ?? CharConstants.empty).trim();
    if (topic.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.taskTitleEmpty);
    }
    final refusal = _refusalOf(body);
    if (refusal != null) return refusal;

    final category = TaskCategoryEnum.fromName(body['category'] as String?);
    if (category == null || category.kind.name != body['kind']) {
      return MockResponse.fail(422, FailureMessageKey.taskCategoryInvalid);
    }
    final repeat = TaskRepeatEnum.fromName(body['repeat'] as String?);
    if (repeat == null) {
      return MockResponse.fail(422, FailureMessageKey.unexpectedResponse);
    }
    final start = body['startMinute'] as int? ?? -1;
    if (start < 0 || start >= TaskPlanRules.minutesPerDay) {
      return MockResponse.fail(422, FailureMessageKey.taskTimeInvalid);
    }

    final from = DateTime.parse(body['from']! as String);
    final until = DateTime.parse(body['until']! as String);
    final written = <Map<String, Object?>>[];
    for (
      DateTime day = DateTime(from.year, from.month, from.day);
      !day.isAfter(until);
      day = DateTime(day.year, day.month, day.day + 1)
    ) {
      if (!repeat.occursOn(day, from: from)) continue;
      final row = <String, Object?>{
        'id': _store.nextId('task'),
        'childId': request.id,
        'title': topic,
        'category': category.name,
        'scheduledAt': day.add(Duration(minutes: start)).toIso8601String(),
        'durationMinutes': body['durationMinutes'],
        'points': body['points'],
        'completedAt': null,
      };
      _store.tasks.add(row);
      written.add(row);
    }
    return MockResponse.created(written);
  }

  MockResponse _updateTask(MockRequest request) {
    final task = _store.findById(_store.tasks, request.id);
    if (task == null) {
      return MockResponse.fail(404, FailureMessageKey.unexpectedResponse);
    }
    if (task['completedAt'] != null) {
      return MockResponse.fail(409, FailureMessageKey.taskAlreadyCompleted);
    }

    final body = request.body;
    final title = (body['title'] as String? ?? CharConstants.empty).trim();
    if (title.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.taskTitleEmpty);
    }
    final refusal = _refusalOf(body);
    if (refusal != null) return refusal;

    task
      ..['title'] = title
      ..['category'] = body['category']
      ..['scheduledAt'] = body['scheduledAt']
      ..['durationMinutes'] = body['durationMinutes']
      ..['points'] = body['points'];
    return MockResponse.ok(task);
  }

  MockResponse _deleteTask(MockRequest request) {
    final task = _store.findById(_store.tasks, request.id);
    if (task == null) {
      return MockResponse.fail(404, FailureMessageKey.unexpectedResponse);
    }
    if (task['completedAt'] != null) {
      return MockResponse.fail(409, FailureMessageKey.taskAlreadyCompleted);
    }
    _store.tasks.remove(task);
    return const MockResponse.noContent();
  }

  MockResponse? _refusalOf(Map<String, Object?> body) {
    final points = body['points'] as int? ?? 0;
    if (points < PointsRules.minTaskPoints ||
        points > PointsRules.maxTaskPoints) {
      return MockResponse.fail(422, FailureMessageKey.taskPointsInvalid);
    }
    final minutes = body['durationMinutes'] as int? ?? 0;
    if (minutes < PointsRules.minTaskMinutes ||
        minutes > PointsRules.maxTaskMinutes) {
      return MockResponse.fail(422, FailureMessageKey.taskDurationInvalid);
    }
    return null;
  }

  static String _dayKey(DateTime day) =>
      '${day.year}-${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';
}
