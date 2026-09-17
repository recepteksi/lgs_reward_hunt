import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_series_end_enum.dart';
import 'package:lgs_reward_hunt/domain/task/interfaces/task_repository_interface.dart';

/// A parent adds a task from a day, once or repeating until an end.
///
/// A task with no topic stops here. The series' last day is the end enum's
/// answer — a number of weeks, or the day before the exam — and the backend
/// writes the task on every day in between its repeat falls on.
@injectable
final class AddTaskSeriesUseCase {
  const AddTaskSeriesUseCase(this._tasks);

  final TaskRepositoryInterface _tasks;

  Future<Either<Failure, List<TaskEntity>>> call({
    required String childId,
    required TaskTemplateEntity template,
    required DateTime from,
    required TaskSeriesEndEnum end,
    required DateTime examDate,
  }) async {
    if (!template.hasTopic) {
      return const Left(ValidationFailure(FailureMessageKey.taskTitleEmpty));
    }
    return _tasks.addSeries(
      childId: childId,
      template: template,
      from: from,
      until: end.lastDay(from: from, examDate: examDate),
    );
  }
}
