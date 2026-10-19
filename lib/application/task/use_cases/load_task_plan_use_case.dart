import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/task/interfaces/task_plan_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/task/value_objects/task_plan_value_object.dart';

/// The plan the task setup step opens with.
///
/// The parent's own saved plan if there is one — a parent who comes back to
/// this step finds what they left — and otherwise the standard study day the
/// app suggests. The parent comes from the session, never from the page.
@injectable
final class LoadTaskPlanUseCase {
  const LoadTaskPlanUseCase(this._session, this._plans);

  final SessionRepositoryInterface _session;

  final TaskPlanRepositoryInterface _plans;

  Future<Either<Failure, TaskPlanValueObject>> call() async {
    final session = await _session.read();
    if (session.isLeft) return Left(session.left);

    final String? parentId = session.right.parentId;
    if (parentId == null) {
      return const Left(UnauthorizedFailure(FailureMessageKey.notSignedIn));
    }

    final saved = await _plans.planOf(parentId);
    if (saved.isLeft || !saved.right.isEmpty) return saved;

    return _plans.standardPlan();
  }
}
