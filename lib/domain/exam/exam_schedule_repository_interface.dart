import 'package:lgs_reward_hunt/core/result/result.dart';

/// Where the exam date comes from.
///
/// Declared here, in the layer that needs it, and implemented in the layer that
/// can — the domain has no opinion about whether the date arrives from a remote
/// config, a bundled asset or a database.
///
/// The suffix is `Interface` and it is spelled out at the END: a leading `I` is
/// Hungarian notation that reads as noise at every use, and it sorts the port
/// away from the implementation it describes in a file listing.
abstract interface class ExamScheduleRepositoryInterface {
  /// The date of the next LGS, for the given year.
  ///
  /// It changes every year and is announced by the ministry, so it is fetched
  /// rather than compiled in — a hard-coded date turns into a shipped bug every
  /// spring.
  Future<Result<DateTime>> examDateFor(int year);
}
