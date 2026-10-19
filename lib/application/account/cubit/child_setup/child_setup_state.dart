part of 'child_setup_cubit.dart';

/// What the child setup page is showing.
sealed class ChildSetupState {
  const ChildSetupState();
}

/// The household is being read, or a change to it is being made.
final class ChildSetupLoading extends ChildSetupState {
  const ChildSetupLoading();
}

/// The parent's card and the children under it.
final class ChildSetupLoaded extends ChildSetupState {
  const ChildSetupLoaded(this.household);

  final HouseholdReadModel household;
}

/// The household could not be read or changed.
final class ChildSetupFailed extends ChildSetupState {
  const ChildSetupFailed(this.failure);

  final Failure failure;
}
