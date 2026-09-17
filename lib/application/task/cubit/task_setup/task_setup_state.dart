part of 'task_setup_cubit.dart';

/// What the task setup page is showing.
///
/// Every state but the two loading ones carries the plan, because the list
/// stays on screen while it is saved and after a refusal.
sealed class TaskSetupState {
  const TaskSetupState();
}

/// The plan is being fetched.
final class TaskSetupLoading extends TaskSetupState {
  const TaskSetupLoading();
}

/// The plan could not be fetched; the page is a retry.
final class TaskSetupLoadFailed extends TaskSetupState {
  const TaskSetupLoadFailed(this.failure);

  final Failure failure;
}

/// The plan, being edited.
final class TaskSetupEditing extends TaskSetupState {
  const TaskSetupEditing(this.plan);

  final TaskPlanValueObject plan;
}

/// The plan is being saved; the button waits.
final class TaskSetupSaving extends TaskSetupState {
  const TaskSetupSaving(this.plan);

  final TaskPlanValueObject plan;
}

/// The plan was refused; [failure] says why, under the list.
final class TaskSetupSaveFailed extends TaskSetupState {
  const TaskSetupSaveFailed(this.plan, this.failure);

  final TaskPlanValueObject plan;

  final Failure failure;
}

/// The plan is stored and the fortnight written; the page moves on.
final class TaskSetupSaved extends TaskSetupState {
  const TaskSetupSaved(this.plan);

  final TaskPlanValueObject plan;
}
