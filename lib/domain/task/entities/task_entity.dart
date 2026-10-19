import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_entity.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/points/rules/points_rules.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_status_enum.dart';

/// One thing a parent has asked a child to do on a given day.
///
/// [scheduledAt] carries the day AND the time of day, because both matter to
/// the child: the list is ordered by it and grouped into morning, afternoon
/// and evening from it. [durationMinutes] is what the parent expects it to
/// take, shown beside the time so the day reads as a plan rather than a list.
///
/// [points] is what completing it is worth, fixed when the task is created.
/// It is stored on the task rather than looked up from the subject so that
/// changing what a subject is worth tomorrow cannot silently repay yesterday.
///
/// [completedAt] is the whole of the completion record — null means not done.
/// A separate `isCompleted` flag would be a second thing to keep in step, and
/// the state it permits (done, but with no time) is one nobody designed.
///
/// [statusAt] derives [TaskStatusEnum] and is the only place that derivation
/// lives. [canCompleteAt] answers whether a completion is allowed right now:
/// a task may be completed only on its own calendar day and only once. Both
/// rules are here rather than in a Cubit because the mock backend enforces
/// them too, and a rule written twice is a rule that will disagree with itself.
///
/// [create] refuses a blank title and points or a duration outside
/// [PointsRules] — a task worth 10.000 points empties the reward shop in one
/// evening, and a task worth nothing is not a task.
final class TaskEntity extends BaseEntity {
  const TaskEntity._({
    required this.id,
    required this.childId,
    required this.title,
    required this.category,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.points,
    required this.completedAt,
  });

  @override
  final String id;

  final String childId;

  final String title;

  final TaskCategoryEnum category;

  final DateTime scheduledAt;

  final int durationMinutes;

  final int points;

  final DateTime? completedAt;

  static Either<Failure, TaskEntity> create({
    required String id,
    required String childId,
    required String title,
    required TaskCategoryEnum category,
    required DateTime scheduledAt,
    required int durationMinutes,
    required int points,
    DateTime? completedAt,
  }) {
    if (title.trim().isEmpty) {
      return const Left(ValidationFailure(FailureMessageKey.taskTitleEmpty));
    }
    if (points < PointsRules.minTaskPoints ||
        points > PointsRules.maxTaskPoints) {
      return const Left(ValidationFailure(FailureMessageKey.taskPointsInvalid));
    }
    if (durationMinutes < PointsRules.minTaskMinutes ||
        durationMinutes > PointsRules.maxTaskMinutes) {
      return const Left(
        ValidationFailure(FailureMessageKey.taskDurationInvalid),
      );
    }
    return Right(
      TaskEntity._(
        id: id,
        childId: childId,
        title: title.trim(),
        category: category,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes,
        points: points,
        completedAt: completedAt,
      ),
    );
  }

  bool get isCompleted => completedAt != null;

  TaskStatusEnum statusAt(DateTime now) {
    if (isCompleted) return TaskStatusEnum.completed;
    return _isSameDay(scheduledAt, now) || scheduledAt.isAfter(now)
        ? TaskStatusEnum.pending
        : TaskStatusEnum.missed;
  }

  bool canCompleteAt(DateTime now) =>
      !isCompleted && _isSameDay(scheduledAt, now);

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
