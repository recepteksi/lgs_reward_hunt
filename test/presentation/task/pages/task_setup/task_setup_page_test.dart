import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/task/cubit/task_setup/task_setup_cubit.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/load_task_plan_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/save_task_plan_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_plan_repository.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:lgs_reward_hunt/presentation/task/pages/task_setup/task_setup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';

/// The task setup page against the mock backend, on a small phone.
///
/// It opens on the plan the demo parent already saved, a new line opens its editor, a blank topic is
/// refused with its reason, and a filled one saves and moves on to the reward step.
void main() {
  late DioClient client;

  setUp(() async {
    client = await mockBackend();
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': demoParent(client)['id']! as String,
    });
    const SessionRepository session = SessionRepository();
    final TaskPlanRepository plans = TaskPlanRepository(client);
    getIt.registerFactory<TaskSetupCubit>(
      () => TaskSetupCubit(
        LoadTaskPlanUseCase(session, plans),
        SaveTaskPlanUseCase(session, plans),
      ),
    );
  });

  tearDown(getIt.reset);

  testWidgets('adds a line, refuses it blank, saves it filled', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.dark(AppAccentEnum.yellow),
        locale: const Locale('tr'),
        localizationsDelegates: AppL10n.localizationsDelegates,
        supportedLocales: AppL10n.supportedLocales,
        routerConfig: GoRouter(
          initialLocation: AppRoutePaths.taskSetup.path(),
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutePaths.taskSetup.pathEnd(),
              builder: (_, _) => const TaskSetupPage(),
            ),
            GoRoute(
              path: AppRoutePaths.rewardSetup.pathEnd(),
              builder: (_, _) => const Text('rewards'),
            ),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Çarpanlar ve katlar · 19:00 · 30 dk'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(find.text('Görev ekle'), 300);
    await tester.tap(find.text('Görev ekle'));
    await tester.pumpAndSettle();
    expect(find.text('KONU'), findsOneWidget, reason: 'the new line is open');
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Devam et'));
    await tester.pumpAndSettle();
    expect(
      find.text('Her görevin bir konusu ya da açıklaması olmalı.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), 'Üslü ifadeler');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Devam et'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('rewards'), findsOneWidget);
    expect(client.mockStore.taskPlans[demoParent(client)['id']], hasLength(9));
  });
}
