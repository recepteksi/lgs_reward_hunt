import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_repeat_enum.dart';
import 'package:lgs_reward_hunt/domain/task/rules/draft_rules.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_repository.dart';

import '../../support/mock_backend.dart';

/// The parent's edits through Dio and the mock backend.
void main() {
  final DateTime wednesday = DateTime(2026, 9, 16, 9);
  late DioClient client;
  late TaskRepository tasks;
  late RewardRepository rewards;
  late String childId;

  setUp(() async {
    client = await mockBackend(clock: () => wednesday);
    tasks = TaskRepository(client);
    rewards = RewardRepository(client);
    childId = client.mockStore.children.first['id']! as String;
  });

  TaskTemplateEntity template(TaskRepeatEnum repeat) =>
      TaskTemplateEntity.draft('${DraftRules.idPrefix}t')
          .withTopic('Olasılık')
          .withRepeat(repeat);

  test('a weekend series lands only on the weekends in its range', () async {
    final written = await tasks.addSeries(
      childId: childId,
      template: template(TaskRepeatEnum.weekend),
      from: DateTime(2026, 9, 16),
      until: DateTime(2026, 9, 29),
    );

    expect(written.right.map((t) => t.scheduledAt.day), <int>[19, 20, 26, 27]);
  });

  test('a finished task can be neither changed nor removed', () async {
    final done = client.mockStore.tasks.firstWhere(
      (Map<String, Object?> t) =>
          t['childId'] == childId && t['completedAt'] != null,
    );

    final changed = await tasks.updateTask(
      taskId: done['id']! as String,
      template: template(TaskRepeatEnum.once),
      day: DateTime(2026, 9, 16),
    );
    final removed = await tasks.deleteTask(taskId: done['id']! as String);

    expect(changed.left.messageKey, FailureMessageKey.taskAlreadyCompleted);
    expect(removed.left.messageKey, FailureMessageKey.taskAlreadyCompleted);
  });

  test('a reward someone asked for is kept but no longer listed', () async {
    final parentId = client.mockStore.parents.first['id']! as String;
    final asked = client.mockStore.redemptions.first['rewardId']! as String;
    final fresh = await rewards.createReward(
      parentId: parentId,
      name: 'Müze',
      category: RewardCategoryEnum.fun,
      cost: 100,
    );

    await rewards.removeReward(rewardId: asked);
    await rewards.removeReward(rewardId: fresh.right.id);

    final listed = (await rewards.rewardsFor(parentId)).right;
    expect(listed.any((r) => r.id == asked), isFalse);
    expect(listed.any((r) => r.id == fresh.right.id), isFalse);
    expect(
      client.mockStore.findById(client.mockStore.rewards, asked),
      isNotNull,
    );
    expect(
      client.mockStore.findById(client.mockStore.rewards, fresh.right.id),
      isNull,
    );
  });

  test('re-pricing and switching off change only what was sent', () async {
    final parentId = client.mockStore.parents.first['id']! as String;
    final reward = (await rewards.rewardsFor(parentId)).right.last;

    final priced = await rewards.updateReward(rewardId: reward.id, cost: 420);
    final off = await rewards.updateReward(
      rewardId: reward.id,
      isActive: false,
    );

    expect(priced.right.cost, 420);
    expect(priced.right.isActive, isTrue);
    expect(off.right.cost, 420);
    expect(off.right.isActive, isFalse);
  });
}
