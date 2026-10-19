import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/child_snapshot_cache_interface.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/value_objects/session_value_object.dart';

/// Makes a child the one this device opens on.
///
/// Only the session changes: each child's points, tasks and streak are theirs
/// on the server already, so switching is choosing whose to read, not moving
/// anything. Refused when nobody is signed in, because a child with no parent
/// on the device is a session that cannot exist.
///
/// Choosing a child forgets the child snapshot: the next page must not open
/// with the previous child's name.
@injectable
final class ChooseDeviceChildUseCase {
  const ChooseDeviceChildUseCase(this._session, this._snapshots);

  final SessionRepositoryInterface _session;

  final ChildSnapshotCacheInterface _snapshots;

  Future<Either<Failure, SessionValueObject>> call(String childId) async {
    final session = await _session.read();
    if (session.isLeft) return Left(session.left);
    if (!session.right.isSignedIn) {
      return const Left(UnauthorizedFailure(FailureMessageKey.notSignedIn));
    }

    _snapshots.forget();
    return _session.save(session.right.copyWith(activeChildId: childId));
  }
}
