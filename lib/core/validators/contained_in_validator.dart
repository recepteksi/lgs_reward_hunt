import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// Passes a value that is one of [allowed].
///
/// [messageKey] is the failure reported otherwise.
final class ContainedInValidator<T> extends BaseValueValidator<T> {
  const ContainedInValidator(this.allowed, this.messageKey);

  final List<T> allowed;

  final String messageKey;

  @override
  Either<Failure, T> validate(T value) => allowed.contains(value)
      ? Right(value)
      : Left(ValidationFailure(messageKey));
}
