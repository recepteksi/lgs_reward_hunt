import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_pool_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/reward/value_objects/reward_pool_value_object.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';

/// Saves the reward pool — the last step of setup.
///
/// The pool is re-created here, which is the save-time check: an empty pool
/// or a reward without a name stops before a request is made.
@injectable
final class SaveRewardPoolUseCase {
  const SaveRewardPoolUseCase(this._session, this._pools);

  final SessionRepositoryInterface _session;

  final RewardPoolRepositoryInterface _pools;

  Future<Either<Failure, RewardPoolValueObject>> call(
    RewardPoolValueObject draft,
  ) async {
    final pool = RewardPoolValueObject.create(draft.rewards);
    if (pool.isLeft) return Left(pool.left);

    final session = await _session.read();
    if (session.isLeft) return Left(session.left);

    final String? parentId = session.right.parentId;
    if (parentId == null) {
      return const Left(UnauthorizedFailure(FailureMessageKey.notSignedIn));
    }

    return _pools.savePool(parentId: parentId, pool: pool.right);
  }
}
