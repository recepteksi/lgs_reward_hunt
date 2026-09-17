import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// Passes a list with at least one item.
///
/// [messageKey] is the failure reported for an empty one.
final class NotEmptyListValidator<E> extends BaseValueValidator<List<E>> {
  const NotEmptyListValidator(this.messageKey);

  final String messageKey;

  @override
  Either<Failure, List<E>> validate(List<E> value) =>
      value.isEmpty ? Left(ValidationFailure(messageKey)) : Right(value);
}
