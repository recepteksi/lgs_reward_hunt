import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/domain/exam/value_objects/exam_countdown_value_object.dart';

/// The countdown's arithmetic, which is the one rule this skeleton actually has.
///
/// It is tested at the entity because that is where it lives: computed in the
/// widget it would be re-implemented — differently — by the second screen that
/// showed the same number.
///
/// The calendar-day case is the one that separates the two readings: 2 hours
/// apart, but a day has turned. `Duration.inDays` on the raw difference says 0;
/// a student who went to bed on the 13th and woke on the 14th has lost a day
/// and expects to see it. The floor case is the other end — never a negative
/// number, because "-3 days" is not a countdown, it is a bug the user reads
/// before we do.
void main() {
  ExamCountdownValueObject build(DateTime examDate, DateTime now) {
    final result = ExamCountdownValueObject.create(
      examDate: examDate,
      now: now,
    );
    return switch (result) {
      Right(:final value) => value,
      Left(:final value) => fail(
        'expected a countdown, got ${value.messageKey}',
      ),
    };
  }

  test('counts whole calendar days, not 24-hour blocks', () {
    final countdown = build(
      DateTime(2026, 6, 15, 9),
      DateTime(2026, 6, 14, 23),
    );

    expect(countdown.daysRemaining, 1);
  });

  test('says zero on exam day rather than counting the hours left', () {
    final countdown = build(DateTime(2026, 6, 14, 9), DateTime(2026, 6, 14, 7));

    expect(countdown.daysRemaining, 0);
  });

  test('floors at zero once the exam has passed', () {
    final countdown = build(DateTime(2026, 6, 14, 9), DateTime(2026, 6, 17, 9));

    expect(countdown.daysRemaining, 0);
    expect(countdown.remaining, Duration.zero);
    expect(countdown.isUpcoming, isFalse);
  });

  test('refuses a date that cannot be a real exam', () {
    final result = ExamCountdownValueObject.create(
      examDate: DateTime(1999),
      now: DateTime(2026, 6),
    );

    expect(result.isLeft, isTrue);
  });
}
