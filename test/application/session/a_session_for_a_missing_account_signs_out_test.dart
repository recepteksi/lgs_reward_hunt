import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/sign_out_use_case.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/confirm_session_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/enums/auth_provider_enum.dart';
import 'package:lgs_reward_hunt/domain/auth/interfaces/platform_sign_in_interface.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/platform_identity_value_object.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/mock_backend.dart';

final class _FakePlatform implements PlatformSignInInterface {
  @override
  Future<Either<Failure, PlatformIdentityValueObject>> signIn(
    AuthProviderEnum provider,
  ) async => throw UnimplementedError();

  @override
  Future<void> signOut() async {}
}

/// The app opens on the intro, not on failing pages, when the stored session
/// names a parent or child the backend no longer has. A known session is kept.
void main() {
  late DioClient client;
  const SessionRepository session = SessionRepository();

  setUp(() async => client = await mockBackend());

  ConfirmSessionUseCase confirm() => ConfirmSessionUseCase(
    session,
    AccountRepository(client),
    SignOutUseCase(session, _FakePlatform(), ChildSnapshotCacheRepository()),
  );

  test('a session for a parent the backend lost is signed out', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': 'parent_gone',
      'session.activeChildId': 'child_gone',
    });

    final result = await confirm()();

    expect(result.right.isSignedIn, isFalse);
    expect((await session.read()).right.isSignedIn, isFalse);
  });

  test('a session for a child the backend lost is signed out', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': demoParent(client)['id']! as String,
      'session.activeChildId': 'child_gone',
    });

    final result = await confirm()();

    expect(result.right.isSignedIn, isFalse);
  });

  test('a session the backend knows is kept', () async {
    final String parentId = demoParent(client)['id']! as String;
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': parentId,
      'session.activeChildId': client.mockStore.children.first['id']! as String,
    });

    final result = await confirm()();

    expect(result.right.parentId, parentId);
    expect(result.right.hasChild, isTrue);
  });
}
