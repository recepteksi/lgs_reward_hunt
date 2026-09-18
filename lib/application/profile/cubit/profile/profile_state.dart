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

/// The profile could not be read. The part that needs a load is a retry, and
/// the rest of the tab stays: [snapshot] for the bar, plus the appearance
/// setting and the way into parent mode, which need no server.
final class ProfileFailed extends ProfileState {
  const ProfileFailed(this.failure, this.snapshot);

  final Failure failure;

  final ChildSnapshotReadModel snapshot;
}

/// The profile.
final class ProfileReady extends ProfileState {
  const ProfileReady(this.profile);

  final ProfileReadModel profile;
}
