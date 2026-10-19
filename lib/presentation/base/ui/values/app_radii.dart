/// Corner radii, ascending.
///
/// This design rounds hard — a 48 pixel button carries a 16 radius and a card
/// carries 24 — because the shapes are meant to read as pressable objects
/// rather than as regions of a page. The ladder is short on purpose: a radius
/// that is not on it is a shape nobody can match on the next screen.
///
/// By role: [xs] a progress bar, [sm] a small control, [md] a button or a chip
/// tile, [lg] a task row, [xl] a compact card, [xxl] a card or panel, [xxxl]
/// the navigation bar and a bottom sheet, [round] a pill or a circle — large
/// enough that the shape wins over the number.
abstract final class AppRadii {
  static const double xs = 10;

  static const double sm = 14;

  static const double md = 16;

  static const double lg = 20;

  static const double xl = 22;

  static const double xxl = 24;

  static const double xxxl = 28;

  static const double round = 999;
}
