import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/domain/account/value_objects/child_profile_value_object.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_repeat_enum.dart';
import 'package:lgs_reward_hunt/domain/task/rules/task_plan_rules.dart';
import 'package:lgs_reward_hunt/domain/task/value_objects/task_plan_value_object.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_plan_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_repository.dart';

import '../../support/mock_backend.dart';

/// Saving a task plan through Dio and the mock backend.
///
/// The standard day arrives with its seven lines, saving writes a fortnight of
/// tasks on the days each line repeats, and saving again replaces the future
/// rather than doubling it.
void main() {
  final DateTime wednesday = DateTime(2026, 9, 16, 9);
  late DioClient client;
  late TaskPlanRepository plans;
  late TaskRepository tasks;
  late String parentId;
  late String childId;

  setUp(() async {
    client = await mockBackend(clock: () => wednesday);
    plans = TaskPlanRepository(client);
    tasks = TaskRepository(client);
    final accounts = AccountRepository(client);
    parentId = (await accounts.createParent(name: 'Ayşe')).right.id;
    childId = (await accounts.addChild(
      parentId: parentId,
      profile: ChildProfileValueObject.create(
        name: 'Elif',
        gradeLevel: 8,
        avatarId: 'av_k_03',
      ).right,
    )).right.id;
  });

  test('the standard day comes with its seven lines', () async {
    final standard = (await plans.standardPlan()).right;
    expect(standard.templates, hasLength(7));
  });

  test('saving writes each line on the days it repeats', () async {
    final standard = (await plans.standardPlan()).right;
    final saved = await plans.savePlan(parentId: parentId, plan: standard);
    expect(saved.isRight, isTrue);

    final today = (await tasks.tasksForDay(
      childId: childId,
      day: wednesday,
    )).right;
    final saturday = (await tasks.tasksForDay(
      childId: childId,
      day: DateTime(2026, 9, 19),
    )).right;

    expect(today, hasLength(6));
    expect(saturday, hasLength(4));
    final afterHorizon = (await tasks.tasksForDay(
      childId: childId,
      day: wednesday.add(const Duration(days: TaskPlanRules.horizonDays)),
    )).right;
    expect(afterHorizon, isEmpty);
  });

  test('saving again replaces the future instead of doubling it', () async {
    final standard = (await plans.standardPlan()).right;
    await plans.savePlan(parentId: parentId, plan: standard);
    final daily = TaskPlanValueObject(
      standard.templates
          .where((t) => t.repeat == TaskRepeatEnum.daily)
          .toList(),
    );
    await plans.savePlan(parentId: parentId, plan: daily);

    final today = (await tasks.tasksForDay(
      childId: childId,
      day: wednesday,
    )).right;
    expect(today, hasLength(daily.templates.length));
    expect((await plans.planOf(parentId)).right.templates, hasLength(3));
  });
}
