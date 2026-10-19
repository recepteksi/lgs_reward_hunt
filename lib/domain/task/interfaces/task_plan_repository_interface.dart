import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/task/value_objects/task_plan_value_object.dart';

/// Where the parent's recurring plan comes from and goes to.
///
/// [standardPlan] is the plan the app suggests — "a standard study day" —
/// served rather than built in, because it is content that changes with the
/// school year. [planOf] is the plan a parent has already saved, empty if they
/// have not. [savePlan] stores it and writes the household's children a
/// fortnight of tasks from it, which is why it answers the stored plan: the
/// lines come back with real ids in place of drafts.
abstract interface class TaskPlanRepositoryInterface {
  Future<Either<Failure, TaskPlanValueObject>> standardPlan();

  Future<Either<Failure, TaskPlanValueObject>> planOf(String parentId);

  Future<Either<Failure, TaskPlanValueObject>> savePlan({
    required String parentId,
    required TaskPlanValueObject plan,
  });
}
