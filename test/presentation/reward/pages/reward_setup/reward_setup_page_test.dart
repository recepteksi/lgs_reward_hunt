import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/reward/cubit/reward_setup/reward_setup_cubit.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/load_reward_pool_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/save_reward_pool_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/load_task_plan_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_pool_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_plan_repository.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/reward_setup/reward_setup_page.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';

/// The reward setup page against the mock backend, on a small phone.
///
/// A parent with rewards already opens on them; removing one, adding one with
/// a name and finishing moves on to the device step with the pool as left,
/// under the closing toast that counts the plan and the pool.
void main() {
  late DioClient client;
  late String parentId;

  setUp(() async {
    client = await mockBackend();
    parentId = demoParent(client)['id']! as String;
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': parentId,
    });
    const SessionRepository session = SessionRepository();
    final RewardPoolRepository pools = RewardPoolRepository(client);
    getIt.registerFactory<RewardSetupCubit>(
      () => RewardSetupCubit(
        LoadRewardPoolUseCase(session, pools),
        SaveRewardPoolUseCase(session, pools),
        LoadTaskPlanUseCase(session, TaskPlanRepository(client)),
      ),
    );
  });

  tearDown(getIt.reset);

  testWidgets('edits the pool and finishes setup', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light(AppAccentEnum.green),
        locale: const Locale('tr'),
        localizationsDelegates: AppL10n.localizationsDelegates,
        supportedLocales: AppL10n.supportedLocales,
        routerConfig: GoRouter(
          initialLocation: AppRoutePaths.rewardSetup.path(),
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutePaths.rewardSetup.pathEnd(),
              builder: (_, _) => const RewardSetupPage(),
            ),
            GoRoute(
              path: AppRoutePaths.deviceChild.pathEnd(),
              builder: (_, _) => const Scaffold(body: Text('device')),
            ),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Kablosuz kulaklık'), findsOneWidget);
    expect(find.text('5 ödül · 80P–5000P'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Ödülü sil').last);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Ödül ekle'), 300);
    await tester.tap(find.text('Ödül ekle'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Müze gezisi');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Kurulumu bitir'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('device'), findsOneWidget);
    final active = client.mockStore.rewards.where(
      (Map<String, Object?> r) =>
          r['parentId'] == parentId && r['isActive'] == true,
    );
    expect(active.map((r) => r['name']), contains('Müze gezisi'));
    expect(active, hasLength(5));
    final tasks = client.mockStore.taskPlans[parentId]!.length;
    expect(
      find.text('Kurulum tamam · $tasks görev, 5 ödül hazır'),
      findsOneWidget,
    );
  });
}
