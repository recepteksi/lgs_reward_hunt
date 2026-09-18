import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_repository_interface.dart';

/// A parent re-prices a reward or switches it on or off.
@injectable
final class UpdateRewardUseCase {
  const UpdateRewardUseCase(this._rewards);

  final RewardRepositoryInterface _rewards;

  Future<Either<Failure, RewardEntity>> call({
    required String rewardId,
    int? cost,
    bool? isActive,
  }) =>
      _rewards.updateReward(rewardId: rewardId, cost: cost, isActive: isActive);
}
