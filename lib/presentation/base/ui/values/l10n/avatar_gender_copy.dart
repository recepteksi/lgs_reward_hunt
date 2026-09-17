import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_gender_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns an [AvatarGenderEnum] into the word on its catalogue tab.
///
/// The one place the mapping happens, like `passwordRuleCopy`: a third tab
/// fails to compile here rather than appearing as `AvatarGenderEnum.other`.
String avatarGenderCopy(AppL10n l10n, AvatarGenderEnum gender) =>
    switch (gender) {
      AvatarGenderEnum.girl => l10n.childFormGirl,
      AvatarGenderEnum.boy => l10n.childFormBoy,
    };
