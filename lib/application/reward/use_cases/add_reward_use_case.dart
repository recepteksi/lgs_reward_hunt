import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_repository_interface.dart';

/// A parent adds a reward to the pool. A blank name stops here; the price is
/// the backend's to bound.
@injectable
final class AddRewardUseCase {
  const AddRewardUseCase(this._rewards);

  final RewardRepositoryInterface _rewards;

  Future<Either<Failure, RewardEntity>> call({
    required String parentId,
    required String name,
    required RewardCategoryEnum category,
    required int cost,
  }) async {
    if (name.trim().isEmpty) {
      return const Left(ValidationFailure(FailureMessageKey.rewardNameEmpty));
    }
    return _rewards.createReward(
      parentId: parentId,
      name: name.trim(),
      category: category,
      cost: cost,
    );
  }
}
