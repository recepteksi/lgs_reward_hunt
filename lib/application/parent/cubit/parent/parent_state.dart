part of 'parent_cubit.dart';

/// What the parent's side is showing.
sealed class ParentState {
  const ParentState();
}

/// The dashboard is being read.
final class ParentLoading extends ParentState {
  const ParentLoading();
}

/// The dashboard could not be read; the page is a retry.
final class ParentFailed extends ParentState {
  const ParentFailed(this.failure);

  final Failure failure;
}

/// The parent signed out; the page leaves for the intro.
final class ParentSignedOut extends ParentState {
  const ParentSignedOut();
}

/// Every state with the dashboard on screen.
sealed class ParentShowing extends ParentState {
  const ParentShowing(this.dashboard);

  final ParentDashboardReadModel dashboard;
}

/// The dashboard.
final class ParentReady extends ParentShowing {
  const ParentReady(super.dashboard);
}

/// An action went through and is worth a toast; [notice] says which.
final class ParentDone extends ParentShowing {
  const ParentDone(super.dashboard, this.notice);

  final ParentNoticeEnum notice;
}

/// An action is on its way; controls wait.
final class ParentWorking extends ParentShowing {
  const ParentWorking(super.dashboard);
}

/// An action was refused; [failure] says why.
final class ParentActionFailed extends ParentShowing {
  const ParentActionFailed(super.dashboard, this.failure);

  final Failure failure;
}
