import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// Passes a string with something in it besides whitespace.
///
/// [messageKey] is the failure reported for a blank one.
final class NotBlankValidator extends BaseValueValidator<String> {
  const NotBlankValidator(this.messageKey);

  final String messageKey;

  @override
  Either<Failure, String> validate(String value) =>
      value.trim().isEmpty ? Left(ValidationFailure(messageKey)) : Right(value);
}
