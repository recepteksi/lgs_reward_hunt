import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';

/// The day's plan, and marking bits of it done.
///
/// [tasksForDay] is scoped to one calendar day because that is the unit the
/// child works in and the unit the completion bonus is paid on.
/// [tasksBetween] is every task from one calendar day to another, both
/// included — the map reads its whole window in one request rather than one
/// request a day.
///
/// [completeTask] returns the task as it now stands rather than nothing, so
/// the caller never has to re-read to find out what happened. What it does to
/// the balance is the ledger's business — see the points port.
///
/// The parent's side: [addSeries] writes a task on every day from `from` to
/// `until` its repeat falls on — once, or a rhythm — and answers the tasks
/// written. [updateTask] moves an unfinished task's fields and time on its
/// day; [deleteTask] removes an unfinished one. A finished task cannot be
/// changed or removed: its points are paid.
abstract interface class TaskRepositoryInterface {
  Future<Either<Failure, List<TaskEntity>>> tasksForDay({
    required String childId,
    required DateTime day,
  });

  Future<Either<Failure, List<TaskEntity>>> tasksBetween({
    required String childId,
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, TaskEntity>> createTask({
    required String childId,
    required String title,
    required TaskCategoryEnum category,
    required DateTime scheduledAt,
    required int durationMinutes,
    required int points,
  });

  Future<Either<Failure, TaskEntity>> completeTask({required String taskId});

  Future<Either<Failure, List<TaskEntity>>> addSeries({
    required String childId,
    required TaskTemplateEntity template,
    required DateTime from,
    required DateTime until,
  });

  Future<Either<Failure, TaskEntity>> updateTask({
    required String taskId,
    required TaskTemplateEntity template,
    required DateTime day,
  });

  Future<Either<Failure, void>> deleteTask({required String taskId});
}
