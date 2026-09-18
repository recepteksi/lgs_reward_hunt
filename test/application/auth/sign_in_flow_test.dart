import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/auth/auth_cubit.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/open_session_use_case.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/platform_sign_in_use_case.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/sign_in_use_case.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/enums/auth_provider_enum.dart';
import 'package:lgs_reward_hunt/domain/auth/interfaces/platform_sign_in_interface.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/platform_identity_value_object.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/repositories/auth_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/mock_backend.dart';

/// Signing in, by email or with a platform, and where the app goes next.
///
/// A returning parent lands on their child's map with the session on that
/// child — before, an email sign-in wrote a session with no child and the map
/// had nothing to open, and the demo account's password was refused by the
/// rules meant for making a new one. A new platform account goes on to set a PIN, and a
/// closed sign-in sheet leaves the form as it was.
final class _FakePlatform implements PlatformSignInInterface {
  _FakePlatform(this.answer);

  final Either<Failure, PlatformIdentityValueObject> answer;

  @override
  Future<Either<Failure, PlatformIdentityValueObject>> signIn(
    AuthProviderEnum provider,
  ) async => answer;

  @override
  Future<void> signOut() async {}
}

void main() {
  late DioClient client;
  const SessionRepository session = SessionRepository();

  setUp(() async {
    client = await mockBackend();
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  AuthCubit cubit(Either<Failure, PlatformIdentityValueObject> platform) {
    final AuthRepository auth = AuthRepository(client);
    return AuthCubit(
      SignInUseCase(auth),
      PlatformSignInUseCase(_FakePlatform(platform), auth),
      OpenSessionUseCase(
        AccountRepository(client),
        session,
        ChildSnapshotCacheRepository(),
      ),
    );
  }

  PlatformIdentityValueObject identity(String email) =>
      PlatformIdentityValueObject(
        provider: AuthProviderEnum.google,
        idToken: 'token',
        email: email,
        displayName: 'Deniz Kaya',
      );

  test(
    'a returning parent signs in onto their child, not into setup',
    () async {
      final AuthCubit auth = cubit(Right(identity('x@y.com')));

      await auth.submitSignIn(email: 'ayse@ornek.com', password: 'lgs12345');

      expect(auth.state, isA<AuthSignedIn>());
      expect((auth.state as AuthSignedIn).hasChild, isTrue);
      expect((await session.read()).right.activeChildId, isNotNull);
    },
  );

  test('a returning parent with Google opens on their child too', () async {
    final AuthCubit auth = cubit(Right(identity('ayse@ornek.com')));

    await auth.continueWith(AuthProviderEnum.google);

    expect((auth.state as AuthSignedIn).hasChild, isTrue);
  });

  test('a new parent with Google goes on to set a PIN', () async {
    final AuthCubit auth = cubit(Right(identity('deniz@ornek.com')));

    await auth.continueWith(AuthProviderEnum.google);

    expect(auth.state, isA<AuthNeedsPin>());
    expect(
      client.mockStore.parents.any((p) => p['name'] == 'Deniz Kaya'),
      isTrue,
    );
    expect((await session.read()).right.isSignedIn, isTrue);
  });

  test('closing the sign-in sheet leaves the form as it was', () async {
    final AuthCubit auth = cubit(
      const Left(ValidationFailure(FailureMessageKey.signInCancelled)),
    )..chooseSignIn();

    await auth.continueWith(AuthProviderEnum.apple);

    expect(auth.state, isA<AuthEditing>());
    expect((auth.state as AuthEditing).isSignUp, isFalse);
  });
}
