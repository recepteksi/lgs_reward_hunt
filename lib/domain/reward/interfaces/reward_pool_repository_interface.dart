import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/value_objects/reward_pool_value_object.dart';

/// Where the reward pool the setup step edits comes from and goes to.
///
/// [standardPool] is the starting pool the app suggests, served because it is
/// content. [poolOf] is the parent's active rewards, empty if they have none.
/// [savePool] makes the parent's active rewards exactly the pool: new ones are
/// created, kept ones updated, and a reward left out is retired rather than
/// deleted — its redemptions still point at it. It answers the saved pool,
/// with real ids in place of drafts.
abstract interface class RewardPoolRepositoryInterface {
  Future<Either<Failure, RewardPoolValueObject>> standardPool();

  Future<Either<Failure, RewardPoolValueObject>> poolOf(String parentId);

  Future<Either<Failure, RewardPoolValueObject>> savePool({
    required String parentId,
    required RewardPoolValueObject pool,
  });
}
