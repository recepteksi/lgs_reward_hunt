import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/read_session_use_case.dart';
import 'package:lgs_reward_hunt/application/settings/cubit/appearance/appearance_cubit.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/session/value_objects/session_value_object.dart';
import 'package:lgs_reward_hunt/infrastructure/config/app_config.dart';
import 'package:lgs_reward_hunt/infrastructure/config/flavor_enum.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/presentation/app.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';

/// The entry point for every flavor, and the only file outside a layer.
///
/// There is one `main`, not one per environment: the flavor arrives from the
/// build itself (`--dart-define=FLAVOR=...`, which `flutter run --flavor` sets),
/// so the two builds run identical code and cannot drift. A `main_dev.dart`
/// that grew a line `main_prod.dart` never got is the failure this avoids. A
/// build with no flavor set is a mistake rather than a third environment — but
/// it happens in tests and in a bare `flutter run`, so it falls back to the
/// safer of the two instead of refusing to start.
///
/// This is also the composition root: the one place allowed to see both
/// `infrastructure` and `presentation`, which is why the flavor-dependent
/// values are resolved here and handed to [App] rather than read inside it.
///
/// Dependencies are wired before the first frame so no widget has to cope with
/// a container that is not ready yet — and the stored appearance is restored in
/// the same breath, because a student who chose pink should never see the app
/// open blue.
///
/// Firebase is initialised with the flavor's app before anything else is
/// wired: platform sign-in goes through it.
///
/// While there is no backend, the mock is installed behind Dio here too —
/// before anything can send a request — because it is configuration, and this
/// is the one file that sees both the flag and the client.
///
/// The stored session decides which screen the app opens on. It is read here
/// rather than by a screen, because a screen that asked "should I be showing?"
/// would already be the wrong one; a device that has never been signed in
/// starts at the intro, whose skip is one tap from the account step, and a
/// parent signed in with no child yet comes back to the child setup step.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.flavor = FlavorEnum.values.firstWhere(
    (FlavorEnum flavor) => flavor.name == appFlavor,
    orElse: () => FlavorEnum.dev,
  );

  await Firebase.initializeApp(options: AppConfig.firebaseOptions);

  await configureDependencies();

  if (AppConfig.useMockBackend) await getIt<DioClient>().initMock();

  final AppearanceCubit appearance = getIt<AppearanceCubit>();
  await appearance.restore();

  final session = await getIt<ReadSessionUseCase>()();

  runApp(
    App(
      title: AppConfig.appTitle,
      appearance: appearance,
      showDebugBanner: AppConfig.isDevelopment,
      startAt: session.fold(
        (Failure _) => AppRoutePaths.intro.path(),
        (SessionValueObject value) => !value.isSignedIn
            ? AppRoutePaths.intro.path()
            : value.hasChild
            ? AppRoutePaths.home.path()
            : AppRoutePaths.childSetup.path(),
      ),
    ),
  );
}
