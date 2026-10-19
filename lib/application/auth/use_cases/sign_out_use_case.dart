import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/child_snapshot_cache_interface.dart';
import 'package:lgs_reward_hunt/domain/auth/interfaces/platform_sign_in_interface.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/value_objects/session_value_object.dart';

/// Signs the parent out of this device.
///
/// It needs nothing from the backend: the session, the platform sign-in and
/// the child snapshot all live on the phone. So a parent can always sign out,
/// even when every request is failing, and signing out is how they get unstuck.
/// The answer is the cleared session. The app then opens on the intro.
@injectable
final class SignOutUseCase {
  const SignOutUseCase(this._session, this._platform, this._snapshots);

  final SessionRepositoryInterface _session;

  final PlatformSignInInterface _platform;

  final ChildSnapshotCacheInterface _snapshots;

  Future<Either<Failure, SessionValueObject>> call() async {
    await _platform.signOut();
    _snapshots.forget();
    return _session.clear();
  }
}
