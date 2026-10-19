import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/exam/interfaces/exam_schedule_repository_interface.dart';

/// Supplies the exam date.
///
/// A local table for now, and the seam is the point: the page, the Cubit and
/// the use case already talk to [ExamScheduleRepositoryInterface], so moving
/// the date to remote config later replaces this class and touches nothing
/// else.
///
/// The table holds the ministry's announced Sunday for each year, at a 09:00
/// local start. It is `final` rather than `const` because `DateTime` has no
/// const constructor, so a const map of them does not compile.
///
/// [nextExamAfter] answers the earliest announced exam that has not started
/// by the moment asked about — so in September it is next June's, and on the
/// morning of the exam before nine it is still today's.
@LazySingleton(as: ExamScheduleRepositoryInterface)
final class ExamScheduleRepository implements ExamScheduleRepositoryInterface {
  const ExamScheduleRepository();

  static final Map<int, DateTime> _announcedDates = <int, DateTime>{
    2026: DateTime(2026, 6, 14, 9),
    2027: DateTime(2027, 6, 13, 9),
  };

  @override
  Future<Either<Failure, DateTime>> nextExamAfter(DateTime moment) async {
    final List<DateTime> dates = _announcedDates.values.toList()..sort();
    for (final DateTime date in dates) {
      if (!date.isBefore(moment)) return Right(date);
    }

    return const Left(ValidationFailure(FailureMessageKey.examDateMissing));
  }
}
