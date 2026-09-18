import 'package:lgs_reward_hunt/core/base/base_read_model.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/points/entities/points_account_entity.dart';
import 'package:lgs_reward_hunt/domain/progress/enums/achievement_enum.dart';
import 'package:lgs_reward_hunt/domain/progress/enums/level_rank_enum.dart';
import 'package:lgs_reward_hunt/domain/progress/enums/progress_day_status_enum.dart';
import 'package:lgs_reward_hunt/domain/progress/rules/progress_rules.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';

/// A child's progress, worked out from their tasks and their ledger.
///
/// A value object: nothing here is stored, every figure is derived each time
/// from [tasks], [account] and [today], so the page cannot disagree with the
/// map or the shop about what was done.
///
/// **Level.** [level] counts from one, a level per `ProgressRules.pointsPerLevel`
/// points ever earned — `PointsAccountEntity.earnedTotal`, not the balance, so
/// spending never demotes anyone. [levelProgress] is how far into the current
/// level, [pointsToNextLevel] what is left, and [rank] its name.
///
/// **Streak.** [streakDays] counts finished days back from today: today counts
/// once it is finished, and an unfinished today does not break the run it
/// continues. A day with nothing planned neither counts nor breaks — a rest
/// day is not a failure.
///
/// **This week.** [weekCompleted] is the tasks done on each day, Monday first,
/// and [weekTodayIndex] is today's place in it. **This month.** [monthDays]
/// is the days of today's month and [dayStatus] how each reads.
///
/// **Totals and badges.** [completedTaskCount] is every task done.
/// [achievementProgress] is how far a badge is, and [isEarned] whether it is.
final class ProgressReadModel extends BaseReadModel {
  const ProgressReadModel({
    required this.tasks,
    required this.account,
    required this.today,
  });

  final List<TaskEntity> tasks;

  final PointsAccountEntity account;

  final DateTime today;

  DateTime get _today => DateTime(today.year, today.month, today.day);

  int get level =>
      account.earnedTotal ~/ ProgressRules.pointsPerLevel + ValueConstants.one;

  int get _pointsIntoLevel =>
      account.earnedTotal % ProgressRules.pointsPerLevel;

  double get levelProgress => _pointsIntoLevel / ProgressRules.pointsPerLevel;

  int get pointsToNextLevel => ProgressRules.pointsPerLevel - _pointsIntoLevel;

  LevelRankEnum get rank => LevelRankEnum.forLevel(level);

  int get completedTaskCount =>
      tasks.where((TaskEntity task) => task.isCompleted).length;

  int get streakDays {
    int streak = ValueConstants.zero;
    DateTime day = _today;
    final DateTime earliest = _today.subtract(
      const Duration(days: ProgressRules.historyDays),
    );
    while (!day.isBefore(earliest)) {
      final List<TaskEntity> ofDay = _tasksOn(day);
      final bool isToday = day == _today;
      if (ofDay.isNotEmpty) {
        final bool complete = ofDay.every(
          (TaskEntity task) => task.isCompleted,
        );
        if (complete) {
          streak++;
        } else if (!isToday) {
          break;
        }
      }
      day = DateTime(day.year, day.month, day.day - ValueConstants.one);
    }
    return streak;
  }

  int get weekTodayIndex => _today.weekday - DateTime.monday;

  List<int> get weekCompleted {
    final DateTime monday = DateTime(
      _today.year,
      _today.month,
      _today.day - weekTodayIndex,
    );
    return <int>[
      for (int offset = 0; offset < DateTime.daysPerWeek; offset++)
        _tasksOn(DateTime(monday.year, monday.month, monday.day + offset))
            .where((TaskEntity task) => task.isCompleted)
            .length,
    ];
  }

  List<DateTime> get monthDays {
    final int length = DateTime(_today.year, _today.month + 1, 0).day;
    return <DateTime>[
      for (int day = 1; day <= length; day++)
        DateTime(_today.year, _today.month, day),
    ];
  }

  ProgressDayStatusEnum dayStatus(DateTime day) {
    final DateTime date = DateTime(day.year, day.month, day.day);
    if (date == _today) return ProgressDayStatusEnum.today;
    final List<TaskEntity> ofDay = _tasksOn(date);
    return ofDay.isNotEmpty && ofDay.every((TaskEntity t) => t.isCompleted)
        ? ProgressDayStatusEnum.complete
        : ProgressDayStatusEnum.open;
  }

  int get _practiceExamsDone => tasks
      .where(
        (TaskEntity task) =>
            task.isCompleted && task.category == TaskCategoryEnum.practiceExam,
      )
      .length;

  int achievementTarget(AchievementEnum achievement) => switch (achievement) {
    AchievementEnum.weekStreak => ProgressRules.streakAchievementDays,
    AchievementEnum.firstPracticeExam => ValueConstants.one,
    AchievementEnum.practiceMaster => ProgressRules.practiceMasterCount,
  };

  int achievementProgress(AchievementEnum achievement) {
    final int value = switch (achievement) {
      AchievementEnum.weekStreak => streakDays,
      AchievementEnum.firstPracticeExam ||
      AchievementEnum.practiceMaster => _practiceExamsDone,
    };
    final int target = achievementTarget(achievement);
    return value > target ? target : value;
  }

  bool isEarned(AchievementEnum achievement) =>
      achievementProgress(achievement) >= achievementTarget(achievement);

  List<TaskEntity> _tasksOn(DateTime day) => tasks
      .where(
        (TaskEntity task) =>
            task.scheduledAt.year == day.year &&
            task.scheduledAt.month == day.month &&
            task.scheduledAt.day == day.day,
      )
      .toList();

  @override
  List<Object?> get props => <Object?>[tasks, account, today];
}
