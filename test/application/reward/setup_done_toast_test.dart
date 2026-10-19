import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/application/reward/cubit/reward_setup/reward_setup_cubit.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/load_reward_pool_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/save_reward_pool_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/load_task_plan_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_pool_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_plan_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/mock_backend.dart';

/// The end of setup counts what the parent set up.
///
/// The design closes setup with "Kurulum tamam · N görev, M ödül hazır", so
/// finishing the reward step has to know the task plan saved the step before.
void main() {
  test('finishing reward setup counts the saved tasks and rewards', () async {
    final client = await mockBackend();
    final parent = demoParent(client);
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': parent['id']! as String,
    });
    const session = SessionRepository();
    final pools = RewardPoolRepository(client);
    final cubit = RewardSetupCubit(
      LoadRewardPoolUseCase(session, pools),
      SaveRewardPoolUseCase(session, pools),
      LoadTaskPlanUseCase(session, TaskPlanRepository(client)),
    );

    await cubit.load();
    await cubit.save();

    final state = cubit.state as RewardSetupSaved;
    expect(state.taskCount, client.mockStore.taskPlans[parent['id']]!.length);
    expect(state.pool.rewards, isNotEmpty);
    await cubit.close();
  });
}
