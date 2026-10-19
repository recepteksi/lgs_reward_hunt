import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// Passes a string exactly [length] characters long.
///
/// [messageKey] is the failure reported otherwise.
final class ExactLengthValidator extends BaseValueValidator<String> {
  const ExactLengthValidator(this.length, this.messageKey);

  final int length;

  final String messageKey;

  @override
  Either<Failure, String> validate(String value) => value.length == length
      ? Right(value)
      : Left(ValidationFailure(messageKey));
}
