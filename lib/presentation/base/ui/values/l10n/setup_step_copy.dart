import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_step_enum.dart';

/// Turns an [AppSetupStepEnum] into the step's name in the setup header.
///
/// The one place the mapping happens, like `navTabCopy`: a seventh step does
/// not compile until it has a name.
String setupStepCopy(AppL10n l10n, AppSetupStepEnum step) => switch (step) {
  AppSetupStepEnum.account => l10n.setupStepAccount,
  AppSetupStepEnum.password => l10n.setupStepPassword,
  AppSetupStepEnum.parentPin => l10n.setupStepPin,
  AppSetupStepEnum.child => l10n.setupStepChild,
  AppSetupStepEnum.tasks => l10n.setupStepTasks,
  AppSetupStepEnum.rewards => l10n.setupStepRewards,
};
