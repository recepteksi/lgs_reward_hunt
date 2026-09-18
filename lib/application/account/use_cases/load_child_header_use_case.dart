import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/account_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/child_snapshot_cache_interface.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_header_read_model.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/interfaces/avatar_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';

/// Reads the child this device opens on, with their face.
///
/// The child comes from the session, never from a page. A tab that needs to
/// say whose it is starts here.
///
/// A header read is remembered in the child snapshot, so the next page opens
/// with it.
@injectable
final class LoadChildHeaderUseCase {
  const LoadChildHeaderUseCase(
    this._session,
    this._accounts,
    this._avatars,
    this._snapshots,
  );

  final SessionRepositoryInterface _session;

  final AccountRepositoryInterface _accounts;

  final AvatarRepositoryInterface _avatars;

  final ChildSnapshotCacheInterface _snapshots;

  Future<Either<Failure, ChildHeaderReadModel>> call() async {
    final session = await _session.read();
    if (session.isLeft) return Left(session.left);

    final String? childId = session.right.activeChildId;
    if (childId == null) {
      return const Left(UnauthorizedFailure(FailureMessageKey.notSignedIn));
    }

    final child = await _accounts.childById(childId);
    if (child.isLeft) return Left(child.left);

    final catalog = await _avatars.catalog();
    if (catalog.isLeft) return Left(catalog.left);

    AvatarEntity? avatar;
    for (final AvatarEntity face in catalog.right) {
      if (face.id == child.right.avatarId) avatar = face;
    }

    final ChildHeaderReadModel header = ChildHeaderReadModel(
      child: child.right,
      avatar: avatar,
    );
    _snapshots.write(_snapshots.snapshot.withHeader(header));
    return Right(header);
  }
}
