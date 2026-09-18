import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_child_header_use_case.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/read_child_snapshot_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/cubit/rewards/rewards_cubit.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/get_reward_shop_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/request_reward_use_case.dart';
import 'package:lgs_reward_hunt/domain/points/enums/points_reason_enum.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/avatar/repositories/avatar_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/points/repositories/points_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/mock_backend.dart';

/// The shop picks up new points after a request.
///
/// A quiet refresh used to run only from the plain ready state, so once a
/// child had asked for a reward the tab stayed on "requested" and points
/// earned on the map never reached the shop again.
void main() {
  test('the shop picks up new points after a request', () async {
    final client = await mockBackend();
    final String childId = client.mockStore.children.first['id']! as String;
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': demoParent(client)['id']! as String,
      'session.activeChildId': childId,
    });
    const SessionRepository session = SessionRepository();
    final ChildSnapshotCacheRepository snapshots =
        ChildSnapshotCacheRepository();
    final AccountRepository accounts = AccountRepository(client);
    final RewardRepository rewards = RewardRepository(client);
    final RewardsCubit cubit = RewardsCubit(
      LoadChildHeaderUseCase(
        session,
        accounts,
        AvatarRepository(client),
        snapshots,
      ),
      GetRewardShopUseCase(
        accounts,
        PointsRepository(client),
        rewards,
        snapshots,
      ),
      RequestRewardUseCase(rewards),
      ReadChildSnapshotUseCase(snapshots),
    );

    await cubit.load();
    final RewardsShowing ready = cubit.state as RewardsShowing;
    final cheapest = ready.shop.rewards.reduce(
      (a, b) => a.cost <= b.cost ? a : b,
    );
    await cubit.request(cheapest);
    expect(cubit.state, isA<RewardsRequested>());
    final int before = (cubit.state as RewardsShowing).shop.balance;

    client.mockStore.addLedger(
      childId: childId,
      amount: 50,
      reason: PointsReasonEnum.taskCompleted.name,
      reference: 'earned-on-the-map',
      at: DateTime.now(),
    );
    await cubit.load(quietly: true);

    expect((cubit.state as RewardsShowing).shop.balance, before + 50);
    await cubit.close();
  });
}
