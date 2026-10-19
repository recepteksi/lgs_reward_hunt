import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/interfaces/task_repository_interface.dart';

/// A parent changes an unfinished task on its day. A blank topic stops here;
/// a finished task is refused by the backend, because its points are paid.
@injectable
final class UpdateTaskUseCase {
  const UpdateTaskUseCase(this._tasks);

  final TaskRepositoryInterface _tasks;

  Future<Either<Failure, TaskEntity>> call({
    required String taskId,
    required TaskTemplateEntity template,
    required DateTime day,
  }) async {
    if (!template.hasTopic) {
      return const Left(ValidationFailure(FailureMessageKey.taskTitleEmpty));
    }
    return _tasks.updateTask(taskId: taskId, template: template, day: day);
  }
}
