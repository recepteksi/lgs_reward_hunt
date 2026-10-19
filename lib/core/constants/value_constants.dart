/// Numeric literals that carry a name rather than a measurement.
///
/// Only values whose meaning is structural belong here — an empty count, the
/// first index, a single step. A design measurement is NOT one of these: a
/// padding, a radius, an icon size or a control height goes to
/// `presentation/base/ui/values/`, where it can be read beside the other
/// measurements it has to agree with.
///
/// [zero] and [one] exist because `0` and `1` mean a dozen different things in
/// a file and none of them is greppable. [zeroDouble] and [oneDouble] are the
/// same two values where Dart wants a `double` — an elevation, an opacity, the
/// end of a clamp — because `0` and `0.0` are not interchangeable in a const
/// context and picking the wrong one is a compile error nobody enjoys reading.
abstract final class ValueConstants {
  static const int zero = 0;

  static const int one = 1;

  static const int two = 2;

  static const int minusOne = -1;

  static const double zeroDouble = 0;

  static const double oneDouble = 1;

  static const double half = 0.5;
}
