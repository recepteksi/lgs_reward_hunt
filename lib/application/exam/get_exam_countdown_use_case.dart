import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/result/result.dart';
import 'package:lgs_reward_hunt/domain/exam/exam_countdown_entity.dart';
import 'package:lgs_reward_hunt/domain/exam/exam_schedule_repository_interface.dart';

/// Reads the exam date and turns it into a countdown.
///
/// One class, one action — the unit a Cubit calls and a test drives. It depends
/// on the domain's port, never on the repository that implements it, which is
/// what lets the whole application layer run without a network.
@injectable
final class GetExamCountdownUseCase {
  const GetExamCountdownUseCase(this._repository);

  final ExamScheduleRepositoryInterface _repository;

  /// The countdown as of [now].
  ///
  /// `now` is a parameter rather than a call to the clock so a test can put the
  /// day before the exam under the assertion instead of waiting for it.
  Future<Result<ExamCountdownEntity>> call({required DateTime now}) async {
    final dateResult = await _repository.examDateFor(now.year);

    return switch (dateResult) {
      Err<DateTime>(:final failure) => Err(failure),
      Ok<DateTime>(:final value) =>
        ExamCountdownEntity.create(examDate: value, now: now),
    };
  }
}
