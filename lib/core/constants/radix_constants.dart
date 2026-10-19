/// The number bases the app converts between.
///
/// Exactly one so far, and it is here rather than typed at the call site for
/// the reason every constant in this folder is: `16` in
/// `toRadixString(16)` is indistinguishable from `16` as a padding, and the two
/// are edited by different people for different reasons.
abstract final class RadixConstants {
  static const int hexadecimal = 16;
}
