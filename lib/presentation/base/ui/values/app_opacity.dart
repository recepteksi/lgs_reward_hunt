/// The three opacities the design fades things to, and no others.
///
/// Fading is how this design says "not now" — a locked reward, a day that has
/// not opened, the unit beside a figure. It says it three ways and they are
/// meaningfully different: [secondary] is still being read, [dimmed] is present
/// but out of reach, and [locked] is the furthest a card goes while remaining
/// on screen, because a reward faded past this stops being a goal.
///
/// A fourth value would not be a fourth meaning, only a fourth guess.
abstract final class AppOpacity {
  static const double secondary = 0.75;

  static const double dimmed = 0.72;

  static const double locked = 0.66;
}
