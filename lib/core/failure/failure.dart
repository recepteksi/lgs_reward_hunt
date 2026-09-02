/// Why something could not be done, in terms the layers above can act on.
///
/// Every variant lives in this file because Dart requires a `sealed` type's
/// subtypes to share its library — the one place the "one declaration per file"
/// rule gives way, and it gives way to the language rather than to convenience.
/// What that buys is an exhaustive `switch` at the UI edge: a new failure kind
/// is a compile error at every place that decides what to show, instead of
/// quietly reaching a default branch that says "something went wrong".
///
/// A [Failure] carries a [messageKey], never a sentence. Copy is resolved from
/// that key in the presentation layer, so the same failure can read differently
/// in Turkish and English, and so a message can be reworded without touching
/// the layer that produced it.
sealed class Failure {
  const Failure(this.messageKey);

  /// A stable key the presentation layer resolves to localized copy.
  final String messageKey;
}

/// The device could not reach the network at all.
final class NetworkFailure extends Failure {
  const NetworkFailure(super.messageKey);
}

/// The request was understood and refused, or the input was not valid.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.messageKey, {this.field});

  /// The input that was wrong, when one field in particular can be blamed.
  final String? field;
}

/// The thing asked for does not exist.
final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.messageKey);
}

/// The caller is not signed in, or the session has expired.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.messageKey);
}

/// Anything not worth a variant of its own — always the last resort.
final class UnknownFailure extends Failure {
  const UnknownFailure(super.messageKey);
}
