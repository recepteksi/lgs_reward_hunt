import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lgs_reward_hunt/app.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/flavors.dart';

/// The entry point for every flavor.
///
/// There is one `main`, not one per environment: the flavor arrives from the
/// build itself (`--dart-define=FLAVOR=...`, which `flutter run --flavor` sets),
/// so the two builds run identical code and cannot drift. A `main_dev.dart`
/// that grew a line `main_prod.dart` never got is the failure this avoids.
///
/// Dependencies are wired before the first frame so no widget has to cope with
/// a container that is not ready yet.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  F.appFlavor = Flavor.values.firstWhere(
    (Flavor flavor) => flavor.name == appFlavor,
    // A build with no flavor set is a mistake, not a third environment — but it
    // happens in tests and in a bare `flutter run`, and failing to start is a
    // worse answer than the safer of the two.
    orElse: () => Flavor.dev,
  );

  await configureDependencies();

  runApp(const App());
}
