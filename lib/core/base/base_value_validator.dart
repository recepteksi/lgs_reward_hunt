import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// One check a value must pass, as halleder's validators are.
///
/// [validate] answers `Right(value)` when the value passes and `Left` with the
/// failure its `messageKey` names when it does not. A validator checks ONE
/// thing, so a value object's rules read as a list and the first one broken is
/// the one the user is told about.
abstract class BaseValueValidator<T> {
  const BaseValueValidator();

  Either<Failure, T> validate(T value);
}
