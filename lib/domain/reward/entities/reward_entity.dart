import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_entity.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/points/rules/points_rules.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';

/// Something in the shop the two of them agreed on.
///
/// A reward is the parent's promise, priced in points. It is created by the
/// parent and never by the app: a catalogue the product ships would be the app
/// deciding what a family's screen time is worth.
///
/// [isActive] retires a reward without deleting it. Deleting one would orphan
/// every redemption that already referenced it, and a child's history of what
/// they earned is exactly the thing this app exists to keep.
///
/// [affordableWith] is the one place that compares a balance to a cost, so the
/// shop card, the redeem action and the mock backend cannot disagree about who
/// can buy what.
///
/// [category] is what the shop filters it under.
///
/// [create] refuses a blank name and a cost outside [PointsRules].
final class RewardEntity extends BaseEntity {
  const RewardEntity._({
    required this.id,
    required this.parentId,
    required this.name,
    required this.category,
    required this.cost,
    required this.isActive,
  });

  @override
  final String id;

  final String parentId;

  final String name;

  final RewardCategoryEnum category;

  final int cost;

  final bool isActive;

  static Either<Failure, RewardEntity> create({
    required String id,
    required String parentId,
    required String name,
    required RewardCategoryEnum category,
    required int cost,
    bool isActive = true,
  }) {
    if (name.trim().isEmpty) {
      return const Left(ValidationFailure(FailureMessageKey.rewardNameEmpty));
    }
    if (cost < PointsRules.minRewardCost || cost > PointsRules.maxRewardCost) {
      return const Left(ValidationFailure(FailureMessageKey.rewardCostInvalid));
    }
    return Right(
      RewardEntity._(
        id: id,
        parentId: parentId,
        name: name.trim(),
        category: category,
        cost: cost,
        isActive: isActive,
      ),
    );
  }

  bool affordableWith(int balance) => isActive && cost <= balance;

  int shortfallFrom(int balance) => cost <= balance ? 0 : cost - balance;
}
