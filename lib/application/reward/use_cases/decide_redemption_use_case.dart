import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_repository_interface.dart';

/// A parent answers a request: yes settles the held points, no gives them back.
///
/// A decided request cannot be decided again — the backend refuses — so a
/// second tap on a slow network cannot pay or refund twice.
@injectable
final class DecideRedemptionUseCase {
  const DecideRedemptionUseCase(this._rewards);

  final RewardRepositoryInterface _rewards;

  Future<Either<Failure, RedemptionEntity>> call({
    required String redemptionId,
    required bool approve,
  }) => approve
      ? _rewards.approve(redemptionId: redemptionId)
      : _rewards.reject(redemptionId: redemptionId);
}
