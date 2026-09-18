import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_entity.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/points/rules/points_rules.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/rules/reward_pool_rules.dart';
import 'package:lgs_reward_hunt/domain/task/rules/draft_rules.dart';

/// A reward as the parent sets up the pool: name, category, price.
///
/// Separate from `RewardEntity` because a reward being set up may have a blank
/// name — the parent is typing it — and a `RewardEntity` never can; the shop
/// and the redemptions rely on that. An entity all the same: the parent edits
/// this row in place, by its [id], which is a draft id
/// (`DraftRules.idPrefix`) until the pool is saved and the server gives
/// the reward its own.
///
/// [create] refuses a price outside `PointsRules`. The blank name is refused
/// when the pool is saved, by `RewardPoolValueObject.create`. The `with…`
/// methods are the page's edits; [withCost] keeps the price inside
/// `RewardPoolRules`.
final class RewardDraftEntity extends BaseEntity {
  const RewardDraftEntity._({
    required this.id,
    required this.name,
    required this.category,
    required this.cost,
  });

  @override
  final String id;

  final String name;

  final RewardCategoryEnum category;

  final int cost;

  static Either<Failure, RewardDraftEntity> create({
    required String id,
    required String name,
    required RewardCategoryEnum category,
    required int cost,
  }) {
    if (cost < PointsRules.minRewardCost || cost > PointsRules.maxRewardCost) {
      return const Left(ValidationFailure(FailureMessageKey.rewardCostInvalid));
    }
    return Right(
      RewardDraftEntity._(id: id, name: name, category: category, cost: cost),
    );
  }

  static RewardDraftEntity draft(String id) => RewardDraftEntity._(
    id: id,
    name: CharConstants.empty,
    category: RewardCategoryEnum.fallback,
    cost: RewardPoolRules.newCost,
  );

  bool get isDraft => id.startsWith(DraftRules.idPrefix);

  bool get hasName => name.trim().isNotEmpty;

  RewardDraftEntity withName(String value) => _copy(name: value);

  RewardDraftEntity withCategory(RewardCategoryEnum value) =>
      _copy(category: value);

  RewardDraftEntity withCost(int value) => _copy(
    cost: value.clamp(RewardPoolRules.minCost, RewardPoolRules.maxCost).toInt(),
  );

  RewardDraftEntity _copy({
    String? name,
    RewardCategoryEnum? category,
    int? cost,
  }) => RewardDraftEntity._(
    id: id,
    name: name ?? this.name,
    category: category ?? this.category,
    cost: cost ?? this.cost,
  );
}
