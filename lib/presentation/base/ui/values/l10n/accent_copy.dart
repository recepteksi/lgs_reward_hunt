import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns an [AppAccentEnum] into the word a student picks it by.
///
/// The ONLY place that mapping happens, for the same reason `failureCopy`
/// exists: the enum names a colour way and refuses to know anyone's language,
/// so a sixth accent added to it fails to compile here rather than appearing on
/// the profile screen as `AppAccentEnum.mor`.
String accentCopy(AppL10n l10n, AppAccentEnum accent) => switch (accent) {
  AppAccentEnum.blue => l10n.accentBlue,
  AppAccentEnum.pink => l10n.accentPink,
  AppAccentEnum.green => l10n.accentGreen,
  AppAccentEnum.yellow => l10n.accentYellow,
  AppAccentEnum.red => l10n.accentRed,
};
