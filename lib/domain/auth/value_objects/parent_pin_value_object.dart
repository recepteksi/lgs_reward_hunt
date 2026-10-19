import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/core/validators/digits_only_validator.dart';
import 'package:lgs_reward_hunt/core/validators/exact_length_validator.dart';
import 'package:lgs_reward_hunt/domain/auth/rules/auth_rules.dart';

/// The four digits that stand between a child and the parent's screens.
///
/// Digits only and exactly [AuthRules.pinLength] long. Anything else is a
/// typo, and letting one through would mean a parent locked out of their own
/// approvals.
///
/// Set in two passes — enter it, then enter it again — and [confirm] is what
/// makes that a rule rather than a screen's good manners: it is the one way
/// to turn a first entry into a PIN, and it fails when the two do not match.
/// [create] checks a single entry, the way the gate checks the PIN typed at it.
final class ParentPinValueObject extends BaseValueObject<String> {
  const ParentPinValueObject(super.value);

  static Either<Failure, ParentPinValueObject> create(String value) {
    final ParentPinValueObject pin = ParentPinValueObject(value);
    return pin.valueObject.map((_) => pin);
  }

  static Either<Failure, ParentPinValueObject> confirm({
    required String first,
    required String second,
  }) {
    if (first != second) {
      return const Left(ValidationFailure(FailureMessageKey.pinMismatch));
    }
    return create(first);
  }

  @override
  List<BaseValueValidator<String>> get validators =>
      const <BaseValueValidator<String>>[
        ExactLengthValidator(AuthRules.pinLength, FailureMessageKey.pinInvalid),
        DigitsOnlyValidator(FailureMessageKey.pinInvalid),
      ];
}
