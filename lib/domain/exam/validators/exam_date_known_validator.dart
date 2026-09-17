import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// Passes an exam date that was actually set.
///
/// A date before [_earliest] is a zero value that came back from storage or the
/// wire, not a year anyone sits the exam in.
final class ExamDateKnownValidator
    extends BaseValueValidator<({DateTime examDate, DateTime now})> {
  const ExamDateKnownValidator();

  static final DateTime _earliest = DateTime.utc(2000);

  @override
  Either<Failure, ({DateTime examDate, DateTime now})> validate(
    ({DateTime examDate, DateTime now}) value,
  ) => value.examDate.isBefore(_earliest)
      ? const Left(ValidationFailure(FailureMessageKey.examDateMissing))
      : Right(value);
}
