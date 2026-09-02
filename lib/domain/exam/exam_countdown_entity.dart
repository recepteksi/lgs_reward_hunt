import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/core/result/result.dart';

/// How long is left until the exam.
///
/// The entity, not a helper: the rule "a day that has started still counts"
/// belongs with the date it is about. Left in the widget it would be
/// re-implemented — differently — the first time a second screen showed the
/// same number.
///
/// Construction goes through [create] and the constructor is private, so an
/// instance that exists is one whose invariants held. A constructor that could
/// throw would put a half-built object within reach.
final class ExamCountdownEntity {
  const ExamCountdownEntity._({required this.examDate, required this.now});

  /// The day the exam is held.
  final DateTime examDate;

  /// The moment the countdown was taken from. Passed in rather than read from
  /// the clock so the entity is testable and so every field agrees about
  /// "now" — reading `DateTime.now()` twice inside one calculation is how a
  /// countdown ends up off by a second at midnight.
  final DateTime now;

  /// Builds a countdown, or says why it cannot.
  static Result<ExamCountdownEntity> create({
    required DateTime examDate,
    required DateTime now,
  }) {
    if (examDate.isBefore(DateTime.utc(2000))) {
      return const Err(ValidationFailure(FailureMessageKey.examDateMissing));
    }
    return Ok(ExamCountdownEntity._(examDate: examDate, now: now));
  }

  /// Whether the exam is still ahead.
  bool get isUpcoming => remaining > Duration.zero;

  /// Time left, floored at zero — a passed exam counts down to nothing rather
  /// than into negative numbers.
  Duration get remaining {
    final difference = examDate.difference(now);
    return difference.isNegative ? Duration.zero : difference;
  }

  /// Whole days left.
  ///
  /// Counted between calendar days rather than from the raw difference: a
  /// student checking at 23:00 and again at 01:00 has lost a day, and
  /// `Duration.inDays` on the raw difference would still say the same number
  /// because it truncates 24-hour blocks.
  int get daysRemaining {
    final examDay = DateTime(examDate.year, examDate.month, examDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final days = examDay.difference(today).inDays;
    return days < 0 ? 0 : days;
  }
}
