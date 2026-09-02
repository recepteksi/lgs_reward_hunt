import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/exam/exam_countdown_state.dart';
import 'package:lgs_reward_hunt/application/exam/get_exam_countdown_use_case.dart';
import 'package:lgs_reward_hunt/core/constants/duration_constants.dart';
import 'package:lgs_reward_hunt/core/result/result.dart';

/// Drives the countdown screen.
///
/// The Cubit orchestrates and holds state; it does not compute. How many days
/// are left is [ExamCountdownEntity]'s question, and the fetch is the use
/// case's — leave either here and the rule is unreachable from anywhere else,
/// which is how the same calculation ends up written twice.
///
/// The ticker is the reason this is a Cubit and not a one-shot read: the screen
/// has to keep saying something true as the clock moves, and a timer owned by a
/// widget outlives the widget on the first navigation that forgets to cancel
/// it. [close] is the single place that stops it.
@injectable
final class ExamCountdownCubit extends Cubit<ExamCountdownState> {
  ExamCountdownCubit(this._getCountdown) : super(const ExamCountdownIdle());

  final GetExamCountdownUseCase _getCountdown;
  Timer? _ticker;

  /// Loads the countdown and keeps it current.
  Future<void> load() async {
    emit(const ExamCountdownLoading());
    await _refresh();
    // Armed only after the first successful shape is known, so a failed load
    // does not sit there re-rendering an error every second.
    _ticker ??= Timer.periodic(
      DurationConstants.countdownTick,
      (_) => unawaited(_refresh()),
    );
  }

  Future<void> _refresh() async {
    final result = await _getCountdown(now: DateTime.now());
    // The stream is closed the moment the screen goes away, and a tick already
    // in flight would otherwise emit into it and throw.
    if (isClosed) return;

    emit(switch (result) {
      Ok(:final value) => ExamCountdownLoaded(value),
      Err(:final failure) => ExamCountdownError(failure),
    });
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    _ticker = null;
    return super.close();
  }
}
