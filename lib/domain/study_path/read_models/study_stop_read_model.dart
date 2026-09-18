import 'package:lgs_reward_hunt/core/base/base_read_model.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/study_path/enums/study_stop_status_enum.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';

/// One day on the road to the exam, and the tasks it holds.
///
/// A value object: a stop is its [day] and what is on it, worked out from the
/// tasks each time the map is read. [today] is the calendar day the map was
/// drawn on, so [status] is a fact about that moment rather than a stored
/// flag.
///
/// [isSpecial] is a day with a practice exam on it — the heavier days the map
/// marks with a star. [completedCount], [earnedPoints] and [totalPoints] are
/// the label beside the stop and the ring in the day sheet; [isComplete] is a
/// day with tasks, every one of them done. [canComplete] is whether its tasks
/// may be ticked now: only today's.
final class StudyStopReadModel extends BaseReadModel {
  const StudyStopReadModel({
    required this.day,
    required this.tasks,
    required this.today,
  });

  final DateTime day;

  final List<TaskEntity> tasks;

  final DateTime today;

  StudyStopStatusEnum get status {
    final DateTime date = DateTime(day.year, day.month, day.day);
    final DateTime now = DateTime(today.year, today.month, today.day);
    if (date == now) return StudyStopStatusEnum.today;
    return date.isBefore(now)
        ? StudyStopStatusEnum.passed
        : StudyStopStatusEnum.upcoming;
  }

  bool get isSpecial => tasks.any(
    (TaskEntity task) => task.category == TaskCategoryEnum.practiceExam,
  );

  bool get hasTasks => tasks.isNotEmpty;

  int get completedCount =>
      tasks.where((TaskEntity task) => task.isCompleted).length;

  bool get isComplete => hasTasks && completedCount == tasks.length;

  int get earnedPoints => tasks
      .where((TaskEntity task) => task.isCompleted)
      .fold(
        ValueConstants.zero,
        (int sum, TaskEntity task) => sum + task.points,
      );

  int get totalPoints => tasks.fold(
    ValueConstants.zero,
    (int sum, TaskEntity task) => sum + task.points,
  );

  bool get canComplete => status == StudyStopStatusEnum.today;

  @override
  List<Object?> get props => <Object?>[day, tasks, today];
}
