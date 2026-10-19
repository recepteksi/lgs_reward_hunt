import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/validators/not_blank_validator.dart';

/// The face a child was given from the catalogue.
///
/// A form that has not picked one yet hands in null, which is held as the
/// empty id so the one rule — a face was chosen — covers both.
final class AvatarChoiceValueObject extends BaseValueObject<String> {
  const AvatarChoiceValueObject(String? avatarId)
    : super(avatarId ?? CharConstants.empty);

  @override
  List<BaseValueValidator<String>> get validators =>
      const <BaseValueValidator<String>>[
        NotBlankValidator(FailureMessageKey.childAvatarMissing),
      ];
}
