/// The colour ways a student can choose between.
///
/// Named here rather than in `presentation` because it is a stored preference:
/// what a widget paints is presentation's business, but WHICH of the five was
/// chosen is a fact the app has to keep, and the domain is where facts live
/// with no Flutter under them.
///
/// [fallback] is what a first launch gets, and what a stored value nobody
/// recognises falls back to — a preferences file written by an older build
/// should not be able to leave the app with no colour at all.
enum AccentChoiceEnum {
  blue,
  pink,
  green,
  yellow,
  red;

  static const AccentChoiceEnum fallback = AccentChoiceEnum.blue;

  static AccentChoiceEnum fromName(String? name) =>
      AccentChoiceEnum.values.firstWhere(
        (AccentChoiceEnum choice) => choice.name == name,
        orElse: () => fallback,
      );
}
