import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_kind_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_repeat_enum.dart';
import 'package:lgs_reward_hunt/domain/task/value_objects/task_plan_value_object.dart';

/// The rules a task plan keeps: which days a line falls on, what an edit may
/// change, and what a plan must hold before it can be saved.
void main() {
  final DateTime wednesday = DateTime(2026, 9, 16);
  final DateTime saturday = DateTime(2026, 9, 19);

  TaskTemplateEntity line({
    TaskRepeatEnum repeat = TaskRepeatEnum.daily,
    String topic = 'Basınç',
    int points = 20,
  }) => TaskTemplateEntity.create(
    id: 't1',
    kind: TaskKindEnum.lesson,
    category: TaskCategoryEnum.science,
    topic: topic,
    startMinute: 1140,
    durationMinutes: 25,
    points: points,
    repeat: repeat,
  ).right;

  group('repeat', () {
    test('weekdays skip the weekend and weekend skips the week', () {
      expect(
        TaskRepeatEnum.weekdays.occursOn(wednesday, from: wednesday),
        isTrue,
      );
      expect(
        TaskRepeatEnum.weekdays.occursOn(saturday, from: wednesday),
        isFalse,
      );
      expect(
        TaskRepeatEnum.weekend.occursOn(saturday, from: wednesday),
        isTrue,
      );
    });

    test('once is the saving day and weekly is its weekday', () {
      final DateTime nextWednesday = DateTime(2026, 9, 23);
      expect(
        TaskRepeatEnum.once.occursOn(nextWednesday, from: wednesday),
        isFalse,
      );
      expect(
        TaskRepeatEnum.weekly.occursOn(nextWednesday, from: wednesday),
        isTrue,
      );
    });

    test('no day before the plan was saved has a task', () {
      expect(
        TaskRepeatEnum.daily.occursOn(DateTime(2026, 9, 15), from: wednesday),
        isFalse,
      );
    });
  });

  group('a template', () {
    test('refuses a chore category on a lesson', () {
      final result = TaskTemplateEntity.create(
        id: 't1',
        kind: TaskKindEnum.lesson,
        category: TaskCategoryEnum.dishes,
        topic: 'x',
        startMinute: 0,
        durationMinutes: 25,
        points: 20,
        repeat: TaskRepeatEnum.daily,
      );
      expect(result.left.messageKey, FailureMessageKey.taskCategoryInvalid);
    });

    test('switched to a chore takes a chore category and length', () {
      final chore = line().withKind(TaskKindEnum.chore);
      expect(chore.category.kind, TaskKindEnum.chore);
      expect(TaskKindEnum.chore.minuteOptions, contains(chore.durationMinutes));
    });

    test('keeps its points inside the economy', () {
      expect(line().withPoints(100000).points, lessThanOrEqualTo(200));
      expect(line().withPoints(0).points, greaterThanOrEqualTo(5));
    });
  });

  group('a plan', () {
    test('cannot be saved empty or with a blank topic', () {
      expect(
        TaskPlanValueObject.create(const <TaskTemplateEntity>[])
            .left
            .messageKey,
        FailureMessageKey.taskPlanEmpty,
      );
      expect(
        TaskPlanValueObject.create(<TaskTemplateEntity>[line(topic: ' ')])
            .left
            .messageKey,
        FailureMessageKey.taskTitleEmpty,
      );
    });

    test('counts today only from the lines that fall on today', () {
      final plan = TaskPlanValueObject(<TaskTemplateEntity>[
        line(points: 20),
        line(repeat: TaskRepeatEnum.weekend, points: 10).withTopic('Bulaşık'),
      ]);
      expect(plan.pointsOn(wednesday, from: wednesday), 20);
      expect(plan.pointsOn(saturday, from: wednesday), 30);
    });

    test('gives each added line its own draft id', () {
      final plan = TaskPlanValueObject.empty
          .withNewTemplate()
          .withNewTemplate();
      expect(plan.templates.map((t) => t.id).toSet(), hasLength(2));
      expect(plan.templates.every((t) => t.isDraft), isTrue);
    });
  });
}
