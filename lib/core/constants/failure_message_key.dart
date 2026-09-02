/// Every key a [Failure] can carry, in one place.
///
/// A key typed at the throw site is not checked by anything: the lookup that
/// resolves it answers a miss by echoing what it was asked, so a typo reaches
/// the user as a dotted identifier and nothing logs a problem. Named here, a
/// wrong one does not compile.
///
/// These are keys, not copy. The words live in the ARB catalogues.
abstract final class FailureMessageKey {
  /// No route to the server — the device is offline or the network refused.
  static const String network = 'failure_network';

  /// The server answered, but with something we cannot use.
  static const String unexpectedResponse = 'failure_unexpected_response';

  /// The exam date has not been configured for the current year.
  static const String examDateMissing = 'failure_exam_date_missing';

  /// Anything with no better explanation.
  static const String unknown = 'failure_unknown';
}
