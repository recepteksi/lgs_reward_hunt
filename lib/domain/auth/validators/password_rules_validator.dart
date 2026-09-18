import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/enums/password_rule_enum.dart';

/// Passes a password that meets every [PasswordRuleEnum].
///
/// Length is reported on its own, before the rest, because "too short" is the
/// one a parent can fix without reading the checklist.
final class PasswordRulesValidator extends BaseValueValidator<String> {
  const PasswordRulesValidator();

  @override
  Either<Failure, String> validate(String value) {
    if (!PasswordRuleEnum.minimumLength.isMetBy(value)) {
      return const Left(ValidationFailure(FailureMessageKey.passwordTooShort));
    }
    if (!PasswordRuleEnum.allMetBy(value)) {
      return const Left(ValidationFailure(FailureMessageKey.passwordTooWeak));
    }
    return Right(value);
  }
}
