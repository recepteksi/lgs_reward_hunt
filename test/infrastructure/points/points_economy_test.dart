import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/domain/account/value_objects/child_profile_value_object.dart';
import 'package:lgs_reward_hunt/domain/points/rules/points_rules.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/points/repositories/points_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_repository.dart';

import '../../support/mock_backend.dart';

/// The points economy, driven end to end through Dio and the mock backend.
///
/// These go through the real client rather than a stubbed repository on
/// purpose: the interceptors, the JSON encoding, the status codes and every
/// repository's parsing all run, so what is under test is the path the app
/// actually takes. A test that stubs the repository proves the arithmetic and
/// nothing about whether a single request would work.
///
/// The clock is frozen at a fixed morning so "today" means something the
/// assertions can rely on, and so a run at 23:59 does not fail because the day
/// turned between two calls.
void main() {
  late DioClient client;
  late AccountRepository accounts;
  late TaskRepository tasks;
  late RewardRepository rewards;
  late PointsRepository points;

  final now = DateTime(2026, 9, 3, 9);

  setUp(() async {
    client = await mockBackend(withDemoHousehold: false, clock: () => now);
    accounts = AccountRepository(client);
    tasks = TaskRepository(client);
    rewards = RewardRepository(client);
    points = PointsRepository(client);
  });

  Future<({String parentId, String childId})> household() async {
    final parent = await accounts.createParent(name: 'Ayşe');
    final parentId = parent.right.id;
    final child = await accounts.addChild(
      parentId: parentId,
      profile: ChildProfileValueObject.create(
        name: 'Elif',
        gradeLevel: 8,
        avatarId: 'av_k_03',
      ).right,
    );
    return (parentId: parentId, childId: child.right.id);
  }

  Future<String> addTask(
    String childId, {
    required int points,
    int hour = 19,
    DateTime? day,
  }) async {
    final on = day ?? now;
    final created = await tasks.createTask(
      childId: childId,
      title: 'Matematik — Çarpanlar',
      category: TaskCategoryEnum.math,
      scheduledAt: DateTime(on.year, on.month, on.day, hour),
      durationMinutes: 40,
      points: points,
    );
    return created.right.id;
  }

  Future<int> balanceOf(String childId) async =>
      (await points.accountFor(childId)).right.balance;

  test('completing a task credits exactly its points', () async {
    final home = await household();
    final taskId = await addTask(home.childId, points: 30);

    expect(await balanceOf(home.childId), 0);

    final completed = await tasks.completeTask(taskId: taskId);

    expect(completed.isRight, isTrue);
    expect(completed.right.isCompleted, isTrue);
    expect(await balanceOf(home.childId), 30);
  });

  test('completing the same task twice does not pay twice', () async {
    final home = await household();
    final taskId = await addTask(home.childId, points: 30);
    await tasks.completeTask(taskId: taskId);

    final second = await tasks.completeTask(taskId: taskId);

    expect(second.isLeft, isTrue);
    expect(second.left.messageKey, FailureMessageKey.taskAlreadyCompleted);
    expect(await balanceOf(home.childId), 30);
  });

  test('a task from another day cannot be completed for points', () async {
    final home = await household();
    final yesterday = await addTask(
      home.childId,
      points: 30,
      day: now.subtract(const Duration(days: 1)),
    );

    final result = await tasks.completeTask(taskId: yesterday);

    expect(result.isLeft, isTrue);
    expect(result.left.messageKey, FailureMessageKey.taskNotToday);
    expect(await balanceOf(home.childId), 0);
  });

  test('a day holding one task pays no completion bonus', () async {
    final home = await household();
    final only = await addTask(home.childId, points: 30);

    await tasks.completeTask(taskId: only);

    expect(await balanceOf(home.childId), 30);
  });

  test('finishing every task of the day pays the bonus once', () async {
    final home = await household();
    final first = await addTask(home.childId, points: 30, hour: 17);
    final second = await addTask(home.childId, points: 20, hour: 19);

    await tasks.completeTask(taskId: first);
    expect(await balanceOf(home.childId), 30);

    await tasks.completeTask(taskId: second);

    expect(
      await balanceOf(home.childId),
      30 + 20 + PointsRules.dayCompletionBonus,
    );
  });

  test(
    'asking for a reward takes the points before any parent looks',
    () async {
      final home = await household();
      final taskId = await addTask(home.childId, points: 200);
      await tasks.completeTask(taskId: taskId);
      final reward = await rewards.createReward(
        parentId: home.parentId,
        category: RewardCategoryEnum.fun,
        name: '1 saat ekstra oyun',
        cost: 200,
      );

      final redemption = await rewards.redeem(
        childId: home.childId,
        rewardId: reward.right.id,
      );

      expect(redemption.right.isPending, isTrue);
      expect(await balanceOf(home.childId), 0);
    },
  );

  test('the same points cannot be spent on two pending rewards', () async {
    final home = await household();
    final taskId = await addTask(home.childId, points: 200);
    await tasks.completeTask(taskId: taskId);
    final first = await rewards.createReward(
      parentId: home.parentId,
      category: RewardCategoryEnum.fun,
      name: '1 saat ekstra oyun',
      cost: 200,
    );
    final second = await rewards.createReward(
      parentId: home.parentId,
      category: RewardCategoryEnum.fun,
      name: 'Geç yatma',
      cost: 200,
    );

    await rewards.redeem(childId: home.childId, rewardId: first.right.id);
    final overspend = await rewards.redeem(
      childId: home.childId,
      rewardId: second.right.id,
    );

    expect(overspend.isLeft, isTrue);
    expect(overspend.left.messageKey, FailureMessageKey.insufficientPoints);
    expect(await balanceOf(home.childId), 0);
  });

  test('a reward beyond the balance is refused outright', () async {
    final home = await household();
    final reward = await rewards.createReward(
      parentId: home.parentId,
      category: RewardCategoryEnum.fun,
      name: 'Kablosuz kulaklık',
      cost: 5000,
    );

    final result = await rewards.redeem(
      childId: home.childId,
      rewardId: reward.right.id,
    );

    expect(result.isLeft, isTrue);
    expect(result.left.messageKey, FailureMessageKey.insufficientPoints);
    expect(await balanceOf(home.childId), 0);
  });

  test('approving settles the hold and moves nothing further', () async {
    final home = await household();
    final taskId = await addTask(home.childId, points: 200);
    await tasks.completeTask(taskId: taskId);
    final reward = await rewards.createReward(
      parentId: home.parentId,
      category: RewardCategoryEnum.fun,
      name: '1 saat ekstra oyun',
      cost: 200,
    );
    final redemption = await rewards.redeem(
      childId: home.childId,
      rewardId: reward.right.id,
    );

    final approved = await rewards.approve(redemptionId: redemption.right.id);

    expect(approved.right.isApproved, isTrue);
    expect(await balanceOf(home.childId), 0);
  });

  test('rejecting gives the held points back', () async {
    final home = await household();
    final taskId = await addTask(home.childId, points: 200);
    await tasks.completeTask(taskId: taskId);
    final reward = await rewards.createReward(
      parentId: home.parentId,
      category: RewardCategoryEnum.fun,
      name: '1 saat ekstra oyun',
      cost: 200,
    );
    final redemption = await rewards.redeem(
      childId: home.childId,
      rewardId: reward.right.id,
    );

    final rejected = await rewards.reject(
      redemptionId: redemption.right.id,
      note: 'Bu hafta olmaz, sınav var.',
    );

    expect(rejected.right.parentNote, 'Bu hafta olmaz, sınav var.');
    expect(await balanceOf(home.childId), 200);
  });

  test('a decided request cannot be decided again', () async {
    final home = await household();
    final taskId = await addTask(home.childId, points: 200);
    await tasks.completeTask(taskId: taskId);
    final reward = await rewards.createReward(
      parentId: home.parentId,
      category: RewardCategoryEnum.fun,
      name: '1 saat ekstra oyun',
      cost: 200,
    );
    final redemption = await rewards.redeem(
      childId: home.childId,
      rewardId: reward.right.id,
    );
    await rewards.reject(redemptionId: redemption.right.id);

    final again = await rewards.reject(redemptionId: redemption.right.id);

    expect(again.isLeft, isTrue);
    expect(again.left.messageKey, FailureMessageKey.redemptionNotPending);
    expect(await balanceOf(home.childId), 200);
  });

  test('a link code works once and says so the second time', () async {
    final parent = await accounts.createParent(name: 'Ayşe');
    final code = parent.right.linkCode;

    final first = await accounts.linkChild(linkCode: code, name: 'Elif');
    final second = await accounts.linkChild(linkCode: code, name: 'Kerem');

    expect(first.isRight, isTrue);
    expect(first.right.parentId, parent.right.id);
    expect(second.isLeft, isTrue);
    expect(second.left.messageKey, FailureMessageKey.linkCodeUsed);
  });

  test('a parent only sees approvals from their own children', () async {
    final ours = await household();
    final theirs = await household();
    final taskId = await addTask(theirs.childId, points: 200);
    await tasks.completeTask(taskId: taskId);
    final reward = await rewards.createReward(
      parentId: theirs.parentId,
      category: RewardCategoryEnum.fun,
      name: 'Sinema bileti',
      cost: 200,
    );
    await rewards.redeem(childId: theirs.childId, rewardId: reward.right.id);

    final ourQueue = await rewards.pendingForParent(ours.parentId);
    final theirQueue = await rewards.pendingForParent(theirs.parentId);

    expect(ourQueue.right, isEmpty);
    expect(theirQueue.right, hasLength(1));
  });
}
