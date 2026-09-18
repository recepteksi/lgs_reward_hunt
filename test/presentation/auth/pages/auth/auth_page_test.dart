import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/auth/auth_cubit.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/open_session_use_case.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/platform_sign_in_use_case.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/sign_in_use_case.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/enums/auth_provider_enum.dart';
import 'package:lgs_reward_hunt/domain/auth/interfaces/platform_sign_in_interface.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/platform_identity_value_object.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/repositories/auth_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/auth/auth_page.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';
import '../../../../support/pump_page.dart';

/// A platform whose sign-in sheet is always dismissed.
final class _CancelledPlatform implements PlatformSignInInterface {
  const _CancelledPlatform();

  @override
  Future<Either<Failure, PlatformIdentityValueObject>> signIn(
    AuthProviderEnum provider,
  ) async => const Left(ValidationFailure(FailureMessageKey.signInCancelled));

  @override
  Future<void> signOut() async {}
}

/// The account step on a small phone: the form fits, and the demo parent signs
/// in by email and lands on the map because the household has a child.
void main() {
  setUp(() async {
    final client = await mockBackend();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final AuthRepository auth = AuthRepository(client);
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(
        SignInUseCase(auth),
        PlatformSignInUseCase(const _CancelledPlatform(), auth),
        OpenSessionUseCase(
          AccountRepository(client),
          const SessionRepository(),
          ChildSnapshotCacheRepository(),
        ),
      ),
    );
  });

  tearDown(getIt.reset);

  testWidgets('the demo parent signs in by email and opens the map', (
    WidgetTester tester,
  ) async {
    await pumpPage(
      tester,
      at: AppRoutePaths.auth.path(),
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutePaths.auth.pathEnd(),
          builder: (_, _) => const AuthPage(),
        ),
        stubRoute(AppRoutePaths.home.pathEnd(), 'home'),
        stubRoute(AppRoutePaths.childSetup.pathEnd(), 'child setup'),
      ],
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Giriş yap').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'ayse@ornek.com');
    await tester.enterText(find.byType(TextField).at(1), 'lgs12345');
    await tester.ensureVisible(find.text('Giriş yap').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Giriş yap').last);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
  });
}
