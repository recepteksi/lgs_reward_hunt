import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/task/interfaces/task_plan_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/task/value_objects/task_plan_value_object.dart';

/// Saves the parent's task plan, which writes the children's next fortnight.
///
/// The plan is re-created here, and that is the save-time check: an empty
/// plan or a line with no topic stops before a request is made. What comes back
/// is the stored plan, with real ids in place of the drafts.
@injectable
final class SaveTaskPlanUseCase {
  const SaveTaskPlanUseCase(this._session, this._plans);

  final SessionRepositoryInterface _session;

  final TaskPlanRepositoryInterface _plans;

  Future<Either<Failure, TaskPlanValueObject>> call(
    TaskPlanValueObject draft,
  ) async {
    final plan = TaskPlanValueObject.create(draft.templates);
    if (plan.isLeft) return Left(plan.left);

    final session = await _session.read();
    if (session.isLeft) return Left(session.left);

    final String? parentId = session.right.parentId;
    if (parentId == null) {
      return const Left(UnauthorizedFailure(FailureMessageKey.notSignedIn));
    }

    return _plans.savePlan(parentId: parentId, plan: plan.right);
  }
}
