import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/exam/validators/exam_date_known_validator.dart';

/// How long is left until the exam.
///
/// The value object, not a helper: the rule "a day that has started still counts"
/// belongs with the date it is about. Left in the widget it would be
/// re-implemented — differently — the first time a second screen showed the
/// same number.
///
/// Construction goes through [create], which returns `Right` with a countdown
/// or `Left` with the [Failure] explaining why it could not build one
/// (`ExamDateKnownValidator`), and the constructor is private, so an instance
/// in hand is one whose invariants held.
///
/// [examDate] is the day the exam is held. [now] is the moment the countdown
/// was taken from, passed in rather than read from the clock so the value
/// object is testable and so every field agrees about "now" — reading
/// `DateTime.now()` twice inside one calculation is how a countdown ends up off
/// by a second at midnight.
///
/// [remaining] is the time left, floored at zero: a passed exam counts down to
/// nothing rather than into negative numbers, and [isUpcoming] is that floor
/// read as a question. [daysRemaining] counts between calendar days rather than
/// from the raw difference — a student checking at 23:00 and again at 01:00 has
/// lost a day, and `Duration.inDays` on the raw difference would still say the
/// same number because it truncates 24-hour blocks.
final class ExamCountdownValueObject
    extends BaseValueObject<({DateTime examDate, DateTime now})> {
  const ExamCountdownValueObject._(super.value);

  static Either<Failure, ExamCountdownValueObject> create({
    required DateTime examDate,
    required DateTime now,
  }) {
    final ExamCountdownValueObject countdown = ExamCountdownValueObject._((
      examDate: examDate,
      now: now,
    ));
    return countdown.valueObject.map((_) => countdown);
  }

  DateTime get examDate => value.examDate;

  DateTime get now => value.now;

  bool get isUpcoming => remaining > Duration.zero;

  Duration get remaining {
    final difference = examDate.difference(now);
    return difference.isNegative ? Duration.zero : difference;
  }

  int get daysRemaining {
    final examDay = DateTime(examDate.year, examDate.month, examDate.day);
    final today = DateTime(now.year, now.month, now.day);
    final days = examDay.difference(today).inDays;
    return days < ValueConstants.zero ? ValueConstants.zero : days;
  }

  @override
  List<BaseValueValidator<({DateTime examDate, DateTime now})>>
  get validators =>
      const <BaseValueValidator<({DateTime examDate, DateTime now})>>[
        ExamDateKnownValidator(),
      ];
}
