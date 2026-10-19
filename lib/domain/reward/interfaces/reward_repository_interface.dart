import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';

/// The shop and the approval queue.
///
/// [redeem] is the child asking. It holds the points immediately, which is why
/// it can fail with an insufficient balance — the check and the hold have to
/// happen together or two requests can both pass the check.
///
/// [approve] and [reject] are the parent's side. Only [reject] moves points,
/// giving the held amount back; approving simply settles a hold that already
/// happened.
///
/// The pool: [updateReward] re-prices a reward or switches it on or off;
/// [removeReward] takes it out of the parent's pool — a reward someone has
/// already asked for is kept for their history, just no longer listed.
abstract interface class RewardRepositoryInterface {
  Future<Either<Failure, List<RewardEntity>>> rewardsFor(String parentId);

  Future<Either<Failure, RewardEntity>> createReward({
    required String parentId,
    required String name,
    required RewardCategoryEnum category,
    required int cost,
  });

  Future<Either<Failure, RewardEntity>> updateReward({
    required String rewardId,
    int? cost,
    bool? isActive,
  });

  Future<Either<Failure, void>> removeReward({required String rewardId});

  Future<Either<Failure, RedemptionEntity>> redeem({
    required String childId,
    required String rewardId,
  });

  Future<Either<Failure, List<RedemptionEntity>>> redemptionsFor(
    String childId,
  );

  Future<Either<Failure, List<RedemptionEntity>>> pendingForParent(
    String parentId,
  );

  Future<Either<Failure, RedemptionEntity>> approve({
    required String redemptionId,
  });

  Future<Either<Failure, RedemptionEntity>> reject({
    required String redemptionId,
    String? note,
  });
}
