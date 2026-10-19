part of 'progress_cubit.dart';

/// What the progress tab is showing.
sealed class ProgressState {
  const ProgressState();
}

/// The first load is on its way. [snapshot] is what is already known about
/// the child — shown at once, with skeletons only where it has nothing.
final class ProgressLoading extends ProgressState {
  const ProgressLoading(this.snapshot);

  final ChildSnapshotReadModel snapshot;
}

/// Progress could not be read; the tab is a retry.
final class ProgressFailed extends ProgressState {
  const ProgressFailed(this.failure);

  final Failure failure;
}

/// Whose tab it is, and their progress.
final class ProgressReady extends ProgressState {
  const ProgressReady(this.header, this.progress);

  final ChildHeaderReadModel header;

  final ProgressReadModel progress;
}
