import 'package:lgs_reward_hunt/domain/auth/rules/auth_rules.dart';

/// What a parent's password has to satisfy, one rule at a time.
///
/// An enum rather than a single boolean, because the setup screen shows the
/// three as a checklist that fills in while you type — and a screen that
/// re-derived them from its own regexes would be a second, quieter definition
/// of what a good password is.
///
/// [isMetBy] is the whole rule. `CredentialsValueObject` refuses a password that
/// fails any of them, so the checklist and the validation cannot disagree.
enum PasswordRuleEnum {
  minimumLength,
  digit,
  uppercase;

  static bool allMetBy(String password) => PasswordRuleEnum.values.every(
    (PasswordRuleEnum rule) => rule.isMetBy(password),
  );

  bool isMetBy(String password) => switch (this) {
    PasswordRuleEnum.minimumLength =>
      password.length >= AuthRules.passwordMinLength,
    PasswordRuleEnum.digit => _digit.hasMatch(password),
    PasswordRuleEnum.uppercase => _uppercase.hasMatch(password),
  };
}

final RegExp _digit = RegExp(r'\d');

final RegExp _uppercase = RegExp(r'[A-ZÇĞİÖŞÜ]');
