import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// Where the exam date comes from.
///
/// Declared here, in the layer that needs it, and implemented in the layer that
/// can — the domain has no opinion about whether the date arrives from a remote
/// config, a bundled asset or a database.
///
/// The suffix is `Interface` and it is spelled out at the END: a leading `I` is
/// Hungarian notation that reads as noise at every use, and it sorts the port
/// away from the implementation it describes in a file listing.
///
/// [nextExamAfter] gives the first LGS on or after `moment` — the exam a
/// student is counting towards. It is asked by moment rather than by year
/// because an exam belongs to a school year, not a calendar one: in September
/// this year's June has already gone. The date changes every year and is
/// announced by the ministry, so it is fetched rather than compiled in — a
/// hard-coded date turns into a shipped bug every spring.
abstract interface class ExamScheduleRepositoryInterface {
  Future<Either<Failure, DateTime>> nextExamAfter(DateTime moment);
}
