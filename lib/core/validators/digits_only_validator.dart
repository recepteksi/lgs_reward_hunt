import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// Passes a string made of digits and nothing else.
///
/// [messageKey] is the failure reported otherwise.
final class DigitsOnlyValidator extends BaseValueValidator<String> {
  const DigitsOnlyValidator(this.messageKey);

  static final RegExp _digits = RegExp(r'^\d+$');

  final String messageKey;

  @override
  Either<Failure, String> validate(String value) => _digits.hasMatch(value)
      ? Right(value)
      : Left(ValidationFailure(messageKey));
}
