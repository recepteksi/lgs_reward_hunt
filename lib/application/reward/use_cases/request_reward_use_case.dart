import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_repository_interface.dart';

/// A child asks for a reward, which holds its price until a parent answers.
///
/// The backend checks the balance and holds the points in one step, so two
/// requests cannot both pass against the same points; this asks and hands
/// back the pending request or the refusal.
@injectable
final class RequestRewardUseCase {
  const RequestRewardUseCase(this._rewards);

  final RewardRepositoryInterface _rewards;

  Future<Either<Failure, RedemptionEntity>> call({
    required String childId,
    required String rewardId,
  }) => _rewards.redeem(childId: childId, rewardId: rewardId);
}
