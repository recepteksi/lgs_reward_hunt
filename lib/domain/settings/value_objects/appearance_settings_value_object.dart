import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/domain/settings/enums/accent_choice_enum.dart';
import 'package:lgs_reward_hunt/domain/settings/enums/theme_choice_enum.dart';

/// How the app looks: which of the five colours, and which brightness.
///
/// Both parts are enums, so an instance that exists already holds legal values
/// and [validators] is empty. The type exists so the two travel together: they
/// are read in one go, written in one go, and a screen that changed one while
/// dropping the other is the bug this prevents.
///
/// [initial] is a first launch — the brand's blue, following the device.
final class AppearanceSettingsValueObject
    extends
        BaseValueObject<({AccentChoiceEnum accent, ThemeChoiceEnum theme})> {
  const AppearanceSettingsValueObject({
    required AccentChoiceEnum accent,
    required ThemeChoiceEnum theme,
  }) : super((accent: accent, theme: theme));

  static const AppearanceSettingsValueObject initial =
      AppearanceSettingsValueObject(
        accent: AccentChoiceEnum.fallback,
        theme: ThemeChoiceEnum.fallback,
      );

  AccentChoiceEnum get accent => value.accent;

  ThemeChoiceEnum get theme => value.theme;

  AppearanceSettingsValueObject copyWith({
    AccentChoiceEnum? accent,
    ThemeChoiceEnum? theme,
  }) => AppearanceSettingsValueObject(
    accent: accent ?? this.accent,
    theme: theme ?? this.theme,
  );

  @override
  List<BaseValueValidator<({AccentChoiceEnum accent, ThemeChoiceEnum theme})>>
  get validators => const [];
}
