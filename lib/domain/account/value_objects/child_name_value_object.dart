import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/validators/not_blank_validator.dart';

/// A child's name, trimmed before it is checked for being there.
final class ChildNameValueObject extends BaseValueObject<String> {
  ChildNameValueObject(String raw) : super(raw.trim());

  @override
  List<BaseValueValidator<String>> get validators =>
      const <BaseValueValidator<String>>[
        NotBlankValidator(FailureMessageKey.childNameEmpty),
      ];
}
