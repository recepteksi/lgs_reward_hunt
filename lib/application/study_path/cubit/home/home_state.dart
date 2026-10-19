part of 'home_cubit.dart';

/// What the home page is showing.
///
/// Every state but the first two carries the map, so it never leaves the
/// screen once it has arrived.
sealed class HomeState {
  const HomeState();
}

/// The first load is on its way. [snapshot] is what is already known about
/// the child — shown at once, with skeletons only where it has nothing.
final class HomeLoading extends HomeState {
  const HomeLoading(this.snapshot);

  final ChildSnapshotReadModel snapshot;
}

/// The map could not be read; the page is a retry.
final class HomeFailed extends HomeState {
  const HomeFailed(this.failure);

  final Failure failure;
}

/// The map.
final class HomeReady extends HomeState {
  const HomeReady(this.map);

  final StudyMapReadModel map;
}

/// A task is being ticked; [taskId] is the one waiting.
final class HomeCompleting extends HomeState {
  const HomeCompleting(this.map, this.taskId);

  final StudyMapReadModel map;

  final String taskId;
}

/// Ticking a task was refused; [failure] says why.
final class HomeCompleteFailed extends HomeState {
  const HomeCompleteFailed(this.map, this.failure);

  final StudyMapReadModel map;

  final Failure failure;
}
