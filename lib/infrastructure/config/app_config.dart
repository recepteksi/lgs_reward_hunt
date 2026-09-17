import 'package:firebase_core/firebase_core.dart';
import 'package:lgs_reward_hunt/infrastructure/config/firebase/firebase_options_dev.dart'
    as dev;
import 'package:lgs_reward_hunt/infrastructure/config/firebase/firebase_options_prod.dart'
    as prod;
import 'package:lgs_reward_hunt/infrastructure/config/flavor_enum.dart';

/// What differs between the environments, resolved from the running flavor.
///
/// Read through this rather than by switching on [flavor] at the point of use:
/// a `switch` on the flavor scattered across the codebase is the same value
/// spelled in many places, and the first one that is missed is a dev build
/// talking to production.
///
/// `presentation` may not import this — it takes what it needs from `main`,
/// which is the one place allowed to see both a layer and its configuration.
///
/// [flavor] is the flavor this build was compiled for. It DEFAULTS to
/// [FlavorEnum.dev] and `main` overwrites it from the build. A `late final` here
/// read better but made the whole app unconstructable outside `main` — every
/// test that reached this far died on an uninitialised field, and the fix for
/// that is not ceremony in each test. Dev is the safe end to fall back to, for
/// the same reason `main` falls back to it when the build names no flavor.
/// [appTitle] is the name the OS shows, so a
/// dev build is identifiable in the task switcher rather than looking exactly
/// like production. [apiBaseUrl] is the API this build talks to, and
/// [isDevelopment] whether it may show developer affordances.
///
/// [useMockBackend] is on in every flavor while no backend exists: `main`
/// then installs the in-memory mock behind Dio. The mock keeps its data for
/// the life of the process, so an account made in one run is gone in the next
/// — the demo account in `assets/mock/demo_household.json` is always there.
///
/// [firebaseOptions] is the flavor's Firebase app, in the `lgs-reward-hunt`
/// project — dev and prod are separate apps there, as they are on a phone.
/// [googleServerClientId] is the project's web OAuth client, the audience
/// Google sign-in asks an ID token for. It is one client for the whole
/// Firebase project, so both flavors share it; each flavor's own iOS client
/// reaches `Info.plist` as `GOOGLE_CLIENT_ID` from its xcconfig.
abstract final class AppConfig {
  static FlavorEnum flavor = FlavorEnum.dev;

  static String get appTitle => switch (flavor) {
    FlavorEnum.dev => 'LGS Ödül Avı Dev',
    FlavorEnum.prod => 'LGS Ödül Avı',
  };

  static String get apiBaseUrl => switch (flavor) {
    FlavorEnum.dev => 'https://dev-api.lgsrewardhunt.com',
    FlavorEnum.prod => 'https://api.lgsrewardhunt.com',
  };

  static bool get isDevelopment => flavor == FlavorEnum.dev;

  static const bool useMockBackend = true;

  static const String googleServerClientId =
      '451080433558-hqeos877g2tdcfncjllqe3vo2hc67p09.apps.googleusercontent.com';

  static FirebaseOptions get firebaseOptions => switch (flavor) {
    FlavorEnum.dev => dev.DefaultFirebaseOptions.currentPlatform,
    FlavorEnum.prod => prod.DefaultFirebaseOptions.currentPlatform,
  };
}
