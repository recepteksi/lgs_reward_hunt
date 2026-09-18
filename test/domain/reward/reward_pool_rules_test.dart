import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_draft_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/rules/reward_pool_rules.dart';
import 'package:lgs_reward_hunt/domain/reward/value_objects/reward_pool_value_object.dart';

/// What a reward pool must hold before it can be saved, and how its prices
/// are kept inside the band.
void main() {
  RewardDraftEntity reward(
    String id, {
    String name = 'Sinema',
    int cost = 200,
  }) => RewardDraftEntity.create(
    id: id,
    name: name,
    category: RewardCategoryEnum.fun,
    cost: cost,
  ).right;

  test('a pool cannot be saved empty or with a nameless reward', () {
    expect(
      RewardPoolValueObject.create(const <RewardDraftEntity>[]).left.messageKey,
      FailureMessageKey.rewardPoolEmpty,
    );
    expect(
      RewardPoolValueObject.create(<RewardDraftEntity>[reward('a', name: ' ')])
          .left
          .messageKey,
      FailureMessageKey.rewardNameEmpty,
    );
  });

  test('the summary is the cheapest and the dearest price', () {
    final pool = RewardPoolValueObject(<RewardDraftEntity>[
      reward('a', cost: 350),
      reward('b', cost: 80),
      reward('c', cost: 120),
    ]);
    expect(pool.cheapest, 80);
    expect(pool.dearest, 350);
  });

  test('a price stepped past the band stops at its edge', () {
    expect(reward('a').withCost(100000).cost, RewardPoolRules.maxCost);
    expect(reward('a').withCost(0).cost, RewardPoolRules.minCost);
  });

  test('an unknown category name reads as a free choice', () {
    expect(RewardCategoryEnum.fromName('gadgets'), RewardCategoryEnum.free);
  });
}
