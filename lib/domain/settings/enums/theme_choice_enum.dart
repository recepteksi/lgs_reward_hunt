/// Whether the app follows the device's brightness or overrides it.
///
/// Three answers, not two: "follow the device" is a real choice and the one a
/// student never has to revisit, which is why it is the default. Flutter's own
/// `ThemeMode` says the same thing, but it is a Flutter type and this is a
/// stored preference — the mapping happens once, in `presentation`.
///
/// [fallback] is what a first launch gets, and what an unrecognised stored
/// value falls back to.
enum ThemeChoiceEnum {
  system,
  light,
  dark;

  static const ThemeChoiceEnum fallback = ThemeChoiceEnum.system;

  static ThemeChoiceEnum fromName(String? name) =>
      ThemeChoiceEnum.values.firstWhere(
        (ThemeChoiceEnum choice) => choice.name == name,
        orElse: () => fallback,
      );
}
