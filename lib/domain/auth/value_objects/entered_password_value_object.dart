import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/validators/not_blank_validator.dart';

/// The password an existing account signs in with — checked only for being
/// there.
///
/// The rules a new password must meet (`PasswordValueObject`) are a condition
/// of making one, not of having one: an account opened before a rule changed
/// must still be able to sign in.
final class EnteredPasswordValueObject extends BaseValueObject<String> {
  const EnteredPasswordValueObject(super.value);

  @override
  List<BaseValueValidator<String>> get validators =>
      const <BaseValueValidator<String>>[
        NotBlankValidator(FailureMessageKey.credentialsInvalid),
      ];
}
