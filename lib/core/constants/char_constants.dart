/// Single characters and separators, so no string is built from a bare literal.
///
/// `CharConstants.empty` states the intent that `''` alone does not: a widget
/// showing an empty string because a value is missing is doing something
/// deliberate, and a reader should not have to decide whether the two quotes
/// were a placeholder somebody meant to come back to.
///
/// [zeroDigit] is the character, not the number — it pads a figure, where
/// `ValueConstants.zero` counts one. [middotSpaced] is the separator this
/// design uses between a label and its detail ("19:00 · 40 dk"); it is here
/// rather than in each widget because it is one typographic decision and it
/// appears on every task row in the app.
abstract final class CharConstants {
  static const String empty = '';

  static const String space = ' ';

  static const String zeroDigit = '0';

  static const String dot = '.';

  static const String comma = ',';

  static const String slash = '/';

  static const String colon = ':';

  static const String dash = '-';

  static const String middotSpaced = ' · ';

  static const String at = '@';

  static const String newline = '\n';
}
