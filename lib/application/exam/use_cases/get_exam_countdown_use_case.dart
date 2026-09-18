import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/exam/interfaces/exam_schedule_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/exam/value_objects/exam_countdown_value_object.dart';

/// Reads the exam date and turns it into a countdown.
///
/// One class, one action — the unit a Cubit calls and a test drives. It depends
/// on the domain's port, never on the repository that implements it, which is
/// what lets the whole application layer run without a network.
///
/// `now` is a parameter rather than a call to the clock so a test can put the
/// day before the exam under the assertion instead of waiting for it.
@injectable
final class GetExamCountdownUseCase {
  const GetExamCountdownUseCase(this._repository);

  final ExamScheduleRepositoryInterface _repository;

  Future<Either<Failure, ExamCountdownValueObject>> call({
    required DateTime now,
  }) async {
    final dateResult = await _repository.nextExamAfter(now);

    return switch (dateResult) {
      Left(:final value) => Left(value),
      Right(:final value) => ExamCountdownValueObject.create(
        examDate: value,
        now: now,
      ),
    };
  }
}
