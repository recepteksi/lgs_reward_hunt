import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// A value with no identity, equal to another with the same [value].
///
/// The shape is halleder's `BaseValueObject<T>`: the object wraps [value] and
/// lists the [validators] it must pass, [valueObject] is the first failure or
/// the value, and [isValid] says which. It differs in two ways. A broken rule is
/// a `Failure` with a `messageKey`, as everywhere else in this app, rather than
/// an exception. And the check runs when it is asked for instead of in the
/// constructor, so a value object can still be `const` — `SessionValueObject.none`
/// is one instance, not one per read.
///
/// Equality is by [value] through `Equatable`: two plans with the same lines
/// are the same plan, which is the definition of a value object and what lets a
/// Cubit tell "nothing changed" from "something did".
///
/// A value object made of several parts carries them as a record in [value],
/// each part a value object of its own where it has rules, and lists
/// `ValidPartsValidator` first so a broken part is reported as that part.
abstract class BaseValueObject<T> extends Equatable {
  const BaseValueObject(this.value);

  final T value;

  List<BaseValueValidator<T>> get validators;

  Either<Failure, T> get valueObject {
    for (final BaseValueValidator<T> validator in validators) {
      final Either<Failure, T> result = validator.validate(value);
      if (result.isLeft) return result;
    }
    return Right(value);
  }

  bool get isValid => valueObject.isRight;

  @override
  List<Object?> get props => <Object?>[value];
}
