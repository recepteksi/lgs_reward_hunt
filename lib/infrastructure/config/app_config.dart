import 'package:lgs_reward_hunt/flavors.dart';

/// What differs between the environments, resolved from the running flavor.
///
/// Read through this rather than by asking `F.appFlavor` at the point of use:
/// a `switch` on the flavor scattered across the codebase is the same value
/// spelled in many places, and the first one that is missed is a dev build
/// talking to production.
abstract final class AppConfig {
  /// The API this build talks to.
  static String get apiBaseUrl => switch (F.appFlavor) {
        Flavor.dev => 'https://dev-api.lgsrewardhunt.com',
        Flavor.prod => 'https://api.lgsrewardhunt.com',
      };

  /// Whether this build may show developer affordances.
  static bool get isDevelopment => F.appFlavor == Flavor.dev;
}
