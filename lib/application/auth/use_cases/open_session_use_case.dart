import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/account_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/child_snapshot_cache_interface.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/value_objects/session_value_object.dart';

/// Remembers a parent who has just signed in, on the child they already have.
///
/// A returning parent's household may already hold children, and the device
/// opens on one of them — the first — rather than on nobody: a session with a
/// parent and no child sends a family that finished setup back into it. A new
/// parent has no child yet and the session says so. The answer is the session
/// written, which is what decides where the app goes next.
///
/// Opening a session forgets the child snapshot left by any earlier one.
@injectable
final class OpenSessionUseCase {
  const OpenSessionUseCase(this._accounts, this._session, this._snapshots);

  final AccountRepositoryInterface _accounts;

  final SessionRepositoryInterface _session;

  final ChildSnapshotCacheInterface _snapshots;

  Future<Either<Failure, SessionValueObject>> call(String parentId) async {
    final children = await _accounts.childrenOf(parentId);
    if (children.isLeft) return Left(children.left);

    _snapshots.forget();
    return _session.save(
      SessionValueObject(
        parentId: parentId,
        activeChildId: children.right.isEmpty ? null : children.right.first.id,
      ),
    );
  }
}
