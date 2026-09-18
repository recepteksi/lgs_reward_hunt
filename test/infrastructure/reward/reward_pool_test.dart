import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/domain/reward/value_objects/reward_pool_value_object.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_pool_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_repository.dart';

import '../../support/mock_backend.dart';

/// Saving a reward pool through Dio and the mock backend.
///
/// The suggested pool arrives from `standard_reward_pool.json`, saving creates
/// the rewards, and a reward left out of a later save is retired rather than
/// deleted — the shop stops offering it, its row is still there.
void main() {
  late RewardPoolRepository pools;
  late RewardRepository rewards;
  late String parentId;

  setUp(() async {
    final client = await mockBackend(withDemoHousehold: false);
    pools = RewardPoolRepository(client);
    rewards = RewardRepository(client);
    parentId = (await AccountRepository(client).createParent(name: 'Ayşe'))
        .right
        .id;
  });

  test('the suggested pool comes with its five rewards', () async {
    expect((await pools.standardPool()).right.rewards, hasLength(5));
  });

  test('a reward left out of a later save is retired, not deleted', () async {
    final standard = (await pools.standardPool()).right;
    final saved = (await pools.savePool(
      parentId: parentId,
      pool: standard,
    )).right;
    expect(saved.rewards.every((r) => !r.isDraft), isTrue);

    final kept = RewardPoolValueObject(saved.rewards.skip(1).toList());
    await pools.savePool(parentId: parentId, pool: kept);

    final all = (await rewards.rewardsFor(parentId)).right;
    expect(all, hasLength(5));
    expect(all.where((r) => !r.isActive), hasLength(1));
    expect((await pools.poolOf(parentId)).right.rewards, hasLength(4));
  });
}
