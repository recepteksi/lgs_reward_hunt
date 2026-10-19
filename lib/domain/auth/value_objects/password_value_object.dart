import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/domain/auth/validators/password_rules_validator.dart';

/// A new password, held to every rule a new account's password must meet.
///
/// Only a password being MADE goes through this type. Signing in sends the
/// password the account already has, which the rules of today may not allow —
/// `CredentialsValueObject.existing` checks only that there is one.
final class PasswordValueObject extends BaseValueObject<String> {
  const PasswordValueObject(super.value);

  @override
  List<BaseValueValidator<String>> get validators =>
      const <BaseValueValidator<String>>[PasswordRulesValidator()];
}
