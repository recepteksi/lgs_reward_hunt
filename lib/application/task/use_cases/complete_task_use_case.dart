import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/domain/task/interfaces/task_repository_interface.dart';

/// A child ticks a task done, which pays its points.
///
/// The backend decides whether it may — only on the task's own day, only once
/// — and pays the day's bonus when it is the last one; this asks, and hands
/// back the task as it now stands or the refusal.
@injectable
final class CompleteTaskUseCase {
  const CompleteTaskUseCase(this._tasks);

  final TaskRepositoryInterface _tasks;

  Future<Either<Failure, TaskEntity>> call(String taskId) =>
      _tasks.completeTask(taskId: taskId);
}
