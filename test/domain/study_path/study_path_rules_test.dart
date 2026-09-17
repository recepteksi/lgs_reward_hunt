import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/domain/study_path/enums/study_stop_status_enum.dart';
import 'package:lgs_reward_hunt/domain/study_path/read_models/study_path_read_model.dart';
import 'package:lgs_reward_hunt/domain/study_path/rules/study_map_rules.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';

/// How the road to the exam is laid out from a child's real tasks.
void main() {
  final DateTime today = DateTime(2026, 9, 17, 10);
  final DateTime exam = DateTime(2027, 6, 13, 9);
  int sequence = 0;

  TaskEntity task(
    DateTime day, {
    TaskCategoryEnum category = TaskCategoryEnum.math,
    bool done = false,
    int points = 20,
  }) => TaskEntity.create(
    id: 't${sequence++}',
    childId: 'c',
    title: 'x',
    category: category,
    scheduledAt: DateTime(day.year, day.month, day.day, 19),
    durationMinutes: 30,
    points: points,
    completedAt: done ? day : null,
  ).right;

  test('the road starts two days back and today is the third stop', () {
    final path = StudyPathReadModel.build(
      tasks: const <TaskEntity>[],
      today: today,
      examDate: exam,
    );

    expect(path.stops, hasLength(StudyMapRules.visibleStops));
    expect(path.firstDay, DateTime(2026, 9, 15));
    expect(path.todayIndex, StudyMapRules.stopsBeforeToday);
    expect(path.stops.first.status, StudyStopStatusEnum.passed);
    expect(path.stops.last.status, StudyStopStatusEnum.upcoming);
  });

  test('finishing today moves the walked road one stop further', () {
    final DateTime day = DateTime(2026, 9, 17);
    final open = StudyPathReadModel.build(
      tasks: <TaskEntity>[task(day, done: true), task(day)],
      today: today,
      examDate: exam,
    );
    final finished = StudyPathReadModel.build(
      tasks: <TaskEntity>[task(day, done: true), task(day, done: true)],
      today: today,
      examDate: exam,
    );

    expect(open.reachedCount, 3);
    expect(finished.reachedCount, 4);
    expect(finished.todayStop.earnedPoints, 40);
  });

  test('a day with a practice exam on it is special', () {
    final DateTime saturday = DateTime(2026, 9, 19);
    final path = StudyPathReadModel.build(
      tasks: <TaskEntity>[
        task(saturday, category: TaskCategoryEnum.practiceExam),
      ],
      today: today,
      examDate: exam,
    );

    expect(path.stops[4].isSpecial, isTrue);
    expect(path.stops[3].isSpecial, isFalse);
  });

  test('the road stops at the exam, and counts the days past its end', () {
    final near = StudyPathReadModel.build(
      tasks: const <TaskEntity>[],
      today: today,
      examDate: DateTime(2026, 9, 27, 9),
    );
    final far = StudyPathReadModel.build(
      tasks: const <TaskEntity>[],
      today: today,
      examDate: exam,
    );

    expect(near.lastDay, DateTime(2026, 9, 27));
    expect(near.daysBeyond, 0);
    expect(far.daysBeyond, exam.difference(far.lastDay).inDays);
  });

  test('only today\'s tasks can be ticked', () {
    final path = StudyPathReadModel.build(
      tasks: const <TaskEntity>[],
      today: today,
      examDate: exam,
    );

    expect(path.todayStop.canComplete, isTrue);
    expect(path.stops.first.canComplete, isFalse);
    expect(path.stops.last.canComplete, isFalse);
  });
}
