import 'package:lgs_reward_hunt/domain/auth/enums/password_rule_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns a [PasswordRuleEnum] into the line beside its tick.
///
/// The ONLY place that mapping happens, like `failureCopy`: the rule knows what
/// it checks and refuses to know how to say it, so a fourth rule fails to
/// compile here rather than appearing on screen as `PasswordRuleEnum.symbol`.
String passwordRuleCopy(AppL10n l10n, PasswordRuleEnum rule) => switch (rule) {
  PasswordRuleEnum.minimumLength => l10n.passwordRuleLength,
  PasswordRuleEnum.digit => l10n.passwordRuleDigit,
  PasswordRuleEnum.uppercase => l10n.passwordRuleUppercase,
};
