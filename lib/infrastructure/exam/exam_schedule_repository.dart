import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/core/result/result.dart';
import 'package:lgs_reward_hunt/domain/exam/exam_schedule_repository_interface.dart';

/// Supplies the exam date.
///
/// A local table for now, and the seam is the point: the screen, the Cubit and
/// the use case already talk to [ExamScheduleRepositoryInterface], so moving
/// the date to remote config later replaces this class and touches nothing
/// else.
///
/// The dates are the ministry's announced Sunday for each year. A year that is
/// not listed yet fails rather than guessing — a countdown to a made-up date is
/// worse than one that says it does not know.
@LazySingleton(as: ExamScheduleRepositoryInterface)
final class ExamScheduleRepository implements ExamScheduleRepositoryInterface {
  const ExamScheduleRepository();

  /// `final`, not `const`: `DateTime` has no const constructor, so a const map
  /// of them does not compile. Announced dates, 09:00 local start.
  static final Map<int, DateTime> _announcedDates = <int, DateTime>{
    2026: DateTime(2026, 6, 14, 9),
    2027: DateTime(2027, 6, 13, 9),
  };

  @override
  Future<Result<DateTime>> examDateFor(int year) async {
    final announced = _announcedDates[year];
    if (announced != null) return Ok(announced);

    // Past the last announced year the next exam is still ahead of a student
    // using the app, so fall forward to the following year rather than failing:
    // in July 2026 the countdown should point at 2027, not go blank.
    final next = _announcedDates[year + 1];
    if (next != null) return Ok(next);

    return const Err(ValidationFailure(FailureMessageKey.examDateMissing));
  }
}
