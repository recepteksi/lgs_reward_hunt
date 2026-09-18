import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// Passes a composite value whose every part is valid.
///
/// [parts] picks the value objects out of the composite, in the order they
/// should be reported: the first invalid part's failure is the answer, so a
/// sign-up form with a bad email and a weak password says "email" first.
final class ValidPartsValidator<T> extends BaseValueValidator<T> {
  const ValidPartsValidator(this.parts);

  final List<BaseValueObject<Object?>> Function(T value) parts;

  @override
  Either<Failure, T> validate(T value) {
    for (final BaseValueObject<Object?> part in parts(value)) {
      final Either<Failure, Object?> result = part.valueObject;
      if (result case Left(:final Failure value)) return Left(value);
    }
    return Right(value);
  }
}
