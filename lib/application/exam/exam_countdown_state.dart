import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/exam/exam_countdown_entity.dart';

/// What the countdown screen can be showing.
///
/// `sealed`, so the widget's `switch` is exhaustive and a new state cannot be
/// added without every screen that renders it being made to say what it draws.
/// The alternative — one class with `isLoading`, `failure` and `countdown` all
/// nullable — permits "loading AND failed AND has data", a combination nobody
/// designed and every widget has to guess about.
sealed class ExamCountdownState {
  const ExamCountdownState();
}

/// Nothing has been asked for yet.
final class ExamCountdownIdle extends ExamCountdownState {
  const ExamCountdownIdle();
}

/// The date is being fetched.
final class ExamCountdownLoading extends ExamCountdownState {
  const ExamCountdownLoading();
}

/// The countdown is available.
final class ExamCountdownLoaded extends ExamCountdownState {
  const ExamCountdownLoaded(this.countdown);

  final ExamCountdownEntity countdown;
}

/// The date could not be read.
final class ExamCountdownError extends ExamCountdownState {
  const ExamCountdownError(this.failure);

  final Failure failure;
}
