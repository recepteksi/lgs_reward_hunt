/// Every path in the app, written once.
///
/// A path typed at a call site is a string nothing checks: a typo compiles and
/// fails at the tap. Named here, and named again in [AppRoute] for the routes
/// that are pushed by name, so a rename is one edit rather than a search.
abstract final class RoutePaths {
  /// The countdown and the day's tasks — where a student lands.
  static const String home = '/';
}

/// The name each route is registered under, for `goNamed`.
abstract final class AppRoute {
  static const String home = 'home';
}
