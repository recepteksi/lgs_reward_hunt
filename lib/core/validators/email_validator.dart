import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// Passes a string shaped like an email: something, `@`, something, a dot.
///
/// Deliberately loose — the server is the one that knows whether the address
/// exists; this only catches a typo before a request is spent on it.
/// [messageKey] is the failure reported otherwise.
final class EmailValidator extends BaseValueValidator<String> {
  const EmailValidator(this.messageKey);

  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final String messageKey;

  @override
  Either<Failure, String> validate(String value) => _email.hasMatch(value)
      ? Right(value)
      : Left(ValidationFailure(messageKey));
}
