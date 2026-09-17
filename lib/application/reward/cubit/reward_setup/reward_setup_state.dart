part of 'reward_setup_cubit.dart';

/// What the reward setup page is showing.
///
/// Every state but the two loading ones carries the pool, because the list
/// stays on screen while it is saved and after a refusal.
sealed class RewardSetupState {
  const RewardSetupState();
}

/// The pool is being fetched.
final class RewardSetupLoading extends RewardSetupState {
  const RewardSetupLoading();
}

/// The pool could not be fetched; the page is a retry.
final class RewardSetupLoadFailed extends RewardSetupState {
  const RewardSetupLoadFailed(this.failure);

  final Failure failure;
}

/// The pool, being edited.
final class RewardSetupEditing extends RewardSetupState {
  const RewardSetupEditing(this.pool);

  final RewardPoolValueObject pool;
}

/// The pool is being saved; the button waits.
final class RewardSetupSaving extends RewardSetupState {
  const RewardSetupSaving(this.pool);

  final RewardPoolValueObject pool;
}

/// The pool was refused; [failure] says why, under the list.
final class RewardSetupSaveFailed extends RewardSetupState {
  const RewardSetupSaveFailed(this.pool, this.failure);

  final RewardPoolValueObject pool;

  final Failure failure;
}

/// The pool is stored and setup is finished.
///
/// [taskCount] is how many tasks the saved plan holds, or null when the plan
/// could not be read back.
final class RewardSetupSaved extends RewardSetupState {
  const RewardSetupSaved(this.pool, {required this.taskCount});

  final RewardPoolValueObject pool;

  final int? taskCount;
}
