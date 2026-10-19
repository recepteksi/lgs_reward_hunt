import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';

/// Turns an [AppNavTabEnum] into the word under its icon.
///
/// The ONLY place that mapping happens, for the same reason `failureCopy`
/// exists: the enum names a destination and refuses to know anyone's language,
/// and a `switch` here stops compiling the day a fifth tab is added.
String navTabCopy(AppL10n l10n, AppNavTabEnum tab) => switch (tab) {
  AppNavTabEnum.home => l10n.navHome,
  AppNavTabEnum.rewards => l10n.navRewards,
  AppNavTabEnum.progress => l10n.navProgress,
  AppNavTabEnum.profile => l10n.navProfile,
};
