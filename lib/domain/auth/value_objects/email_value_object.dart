import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/validators/email_validator.dart';

/// An email address, trimmed and lowered before it is checked.
///
/// A parent typing `Ahmet@Mail.com` on Monday and `ahmet@mail.com` on Tuesday
/// is one account, not two — so the value is normalised on the way in and
/// equality compares the normalised form.
final class EmailValueObject extends BaseValueObject<String> {
  EmailValueObject(String raw) : super(raw.trim().toLowerCase());

  @override
  List<BaseValueValidator<String>> get validators =>
      const <BaseValueValidator<String>>[
        EmailValidator(FailureMessageKey.emailInvalid),
      ];
}
