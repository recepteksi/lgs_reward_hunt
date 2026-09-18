import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_repository_interface.dart';

/// A parent takes a reward out of the pool; one somebody has asked for is kept
/// for their history.
@injectable
final class RemoveRewardUseCase {
  const RemoveRewardUseCase(this._rewards);

  final RewardRepositoryInterface _rewards;

  Future<Either<Failure, void>> call(String rewardId) =>
      _rewards.removeReward(rewardId: rewardId);
}
