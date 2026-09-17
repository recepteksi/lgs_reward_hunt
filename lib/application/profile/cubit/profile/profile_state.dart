part of 'profile_cubit.dart';

/// What the profile tab is showing.
sealed class ProfileState {
  const ProfileState();
}

/// The first load is on its way. [snapshot] is what is already known about
/// the child — shown at once, with skeletons only where it has nothing.
final class ProfileLoading extends ProfileState {
  const ProfileLoading(this.snapshot);

  final ChildSnapshotReadModel snapshot;
}

/// The profile could not be read; the tab is a retry.
final class ProfileFailed extends ProfileState {
  const ProfileFailed(this.failure);

  final Failure failure;
}

/// The profile.
final class ProfileReady extends ProfileState {
  const ProfileReady(this.profile);

  final ProfileReadModel profile;
}
