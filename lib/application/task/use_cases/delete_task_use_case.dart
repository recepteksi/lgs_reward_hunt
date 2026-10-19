import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/task/interfaces/task_repository_interface.dart';

/// A parent removes an unfinished task. A finished one is refused by the
/// backend, because its points are paid.
@injectable
final class DeleteTaskUseCase {
  const DeleteTaskUseCase(this._tasks);

  final TaskRepositoryInterface _tasks;

  Future<Either<Failure, void>> call(String taskId) =>
      _tasks.deleteTask(taskId: taskId);
}
