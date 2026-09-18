import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/domain/points/entities/points_account_entity.dart';
import 'package:lgs_reward_hunt/domain/points/entities/points_ledger_entry_entity.dart';
import 'package:lgs_reward_hunt/domain/points/enums/points_reason_enum.dart';
import 'package:lgs_reward_hunt/domain/progress/enums/achievement_enum.dart';
import 'package:lgs_reward_hunt/domain/progress/enums/level_rank_enum.dart';
import 'package:lgs_reward_hunt/domain/progress/enums/progress_day_status_enum.dart';
import 'package:lgs_reward_hunt/domain/progress/read_models/progress_read_model.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';

/// Level, streak, the week and the badges, from tasks and a ledger.
void main() {
  final DateTime wednesday = DateTime(2026, 9, 16, 12);
  int sequence = 0;

  TaskEntity task(
    int day, {
    bool done = true,
    TaskCategoryEnum category = TaskCategoryEnum.math,
  }) => TaskEntity.create(
    id: 't${sequence++}',
    childId: 'c',
    title: 'x',
    category: category,
    scheduledAt: DateTime(2026, 9, day, 19),
    durationMinutes: 30,
    points: 20,
    completedAt: done ? DateTime(2026, 9, day, 20) : null,
  ).right;

  PointsLedgerEntryEntity entry(int amount) => PointsLedgerEntryEntity.create(
    id: 'l${sequence++}',
    childId: 'c',
    amount: amount,
    reason: amount > 0
        ? PointsReasonEnum.taskCompleted
        : PointsReasonEnum.redemptionHeld,
    occurredAt: DateTime(2026, 9, 1),
    reference: 'r',
  ).right;

  ProgressReadModel progress(
    List<TaskEntity> tasks, {
    List<int> ledger = const <int>[],
  }) => ProgressReadModel(
    tasks: tasks,
    account: PointsAccountEntity(
      childId: 'c',
      entries: <PointsLedgerEntryEntity>[for (final int a in ledger) entry(a)],
    ),
    today: wednesday,
  );

  test('spending points never takes a level away', () {
    final earned = progress(const <TaskEntity>[], ledger: <int>[1200]);
    final spent = progress(const <TaskEntity>[], ledger: <int>[1200, -900]);

    expect(earned.level, 3);
    expect(spent.level, 3);
    expect(spent.pointsToNextLevel, 300);
    expect(spent.rank, LevelRankEnum.mapMaster);
  });

  test('an unfinished today does not break the streak it continues', () {
    final p = progress(<TaskEntity>[
      task(13),
      task(14),
      task(15),
      task(16, done: false),
    ]);
    expect(p.streakDays, 3);
  });

  test('a day with nothing planned neither counts nor breaks the streak', () {
    final p = progress(<TaskEntity>[task(12), task(14), task(15)]);
    expect(p.streakDays, 3);
  });

  test('an unfinished day before today ends the streak', () {
    final p = progress(<TaskEntity>[task(13), task(14, done: false), task(15)]);
    expect(p.streakDays, 1);
  });

  test('the week counts done tasks from Monday, with today in place', () {
    final p = progress(<TaskEntity>[task(14), task(14), task(16), task(13)]);
    expect(p.weekTodayIndex, 2);
    expect(p.weekCompleted, <int>[2, 0, 1, 0, 0, 0, 0]);
  });

  test('the month marks finished days and today', () {
    final p = progress(<TaskEntity>[task(10), task(11, done: false)]);
    expect(p.monthDays, hasLength(30));
    expect(p.dayStatus(DateTime(2026, 9, 10)), ProgressDayStatusEnum.complete);
    expect(p.dayStatus(DateTime(2026, 9, 11)), ProgressDayStatusEnum.open);
    expect(p.dayStatus(DateTime(2026, 9, 16)), ProgressDayStatusEnum.today);
  });

  test('practice exams earn the first badge and count towards the last', () {
    final p = progress(<TaskEntity>[
      task(10, category: TaskCategoryEnum.practiceExam),
      task(12, category: TaskCategoryEnum.practiceExam),
    ]);
    expect(p.isEarned(AchievementEnum.firstPracticeExam), isTrue);
    expect(p.isEarned(AchievementEnum.practiceMaster), isFalse);
    expect(p.achievementProgress(AchievementEnum.practiceMaster), 2);
  });
}
