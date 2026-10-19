/// The spacing scale, ascending.
///
/// Named by step rather than by use, because the same gap serves a dozen
/// unrelated things and naming it `cardPadding` only means the next widget
/// picks a raw number instead. A value that is not on this ladder is a value
/// nobody can keep consistent.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}
