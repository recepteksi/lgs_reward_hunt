import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_household_use_case.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/parent_gate/parent_gate_cubit.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/verify_parent_pin_use_case.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/parent/cubit/parent/parent_cubit.dart';
import 'package:lgs_reward_hunt/application/parent/use_cases/load_parent_dashboard_use_case.dart';
import 'package:lgs_reward_hunt/application/progress/use_cases/load_progress_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/add_reward_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/decide_redemption_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/remove_reward_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/update_reward_use_case.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/choose_device_child_use_case.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/read_session_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/add_task_series_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/delete_task_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/update_task_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/repositories/auth_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/avatar/repositories/avatar_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/exam/repositories/exam_schedule_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/points/repositories/points_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_pool_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_repository.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/parent_gate/parent_gate_page.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/parent_page.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';

/// Into the parent's side with the PIN, and answering a request there.
///
/// A wrong PIN is refused and the dots clear; the right one opens the parent
/// page, where the demo child's waiting request is approved and a suggested
/// reward is added to the pool.
void main() {
  final DateTime wednesday = DateTime(2026, 9, 16, 16);
  late DioClient client;

  setUp(() async {
    client = await mockBackend(clock: () => wednesday);
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': demoParent(client)['id']! as String,
      'session.activeChildId': client.mockStore.children.first['id']! as String,
    });
    const SessionRepository session = SessionRepository();
    final AccountRepository accounts = AccountRepository(client);
    final RewardRepository rewards = RewardRepository(client);
    final TaskRepository tasks = TaskRepository(client);
    getIt
      ..registerFactory<ParentGateCubit>(
        () => ParentGateCubit(
          const ReadSessionUseCase(session),
          VerifyParentPinUseCase(AuthRepository(client)),
        ),
      )
      ..registerFactory<ParentCubit>(
        () => ParentCubit(
          LoadParentDashboardUseCase(
            session,
            LoadHouseholdUseCase(session, accounts, AvatarRepository(client)),
            LoadProgressUseCase(
              PointsRepository(client),
              tasks,
              ChildSnapshotCacheRepository(),
            ),
            rewards,
            tasks,
            const ExamScheduleRepository(),
            RewardPoolRepository(client),
          ),
          DecideRedemptionUseCase(rewards),
          ChooseDeviceChildUseCase(session, ChildSnapshotCacheRepository()),
          AddTaskSeriesUseCase(tasks),
          UpdateTaskUseCase(tasks),
          DeleteTaskUseCase(tasks),
          AddRewardUseCase(rewards),
          UpdateRewardUseCase(rewards),
          RemoveRewardUseCase(rewards),
        )..clock = () => wednesday,
      );
  });

  tearDown(getIt.reset);

  Future<void> settle(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  }

  testWidgets('the PIN opens the parent side, where a request is approved', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final GoRouter router = GoRouter(
      initialLocation: '/start',
      routes: <RouteBase>[
        GoRoute(path: '/start', builder: (_, _) => const Text('tabs')),
        GoRoute(
          path: AppRoutePaths.parentGate.pathEnd(),
          builder: (_, _) => const ParentGatePage(),
        ),
        GoRoute(
          path: AppRoutePaths.parent.pathEnd(),
          builder: (_, _) => const ParentPage(),
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light(AppAccentEnum.blue),
        locale: const Locale('tr'),
        localizationsDelegates: AppL10n.localizationsDelegates,
        supportedLocales: AppL10n.supportedLocales,
        routerConfig: router,
      ),
    );
    router.push(AppRoutePaths.parentGate.path());
    await tester.pumpAndSettle();

    for (final String digit in <String>['9', '9', '9', '9']) {
      await tester.tap(find.text(digit));
      await tester.pump();
    }
    await settle(tester);
    expect(find.text('PIN hatalı, tekrar dene.'), findsOneWidget);

    for (final String digit in <String>['1', '2', '3', '4']) {
      await tester.tap(find.text(digit));
      await tester.pump();
    }
    await settle(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Onaylar'), findsOneWidget);

    final String requestId =
        client.mockStore.redemptions.first['id']! as String;
    await tester.tap(find.text('Onayla'));
    for (int step = 0; step < 40; step++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.text('İstek onaylandı.').evaluate().isNotEmpty) break;
    }
    expect(find.text('İstek onaylandı.'), findsOneWidget);
    await settle(tester);

    expect(
      client.mockStore.findById(
        client.mockStore.redemptions,
        requestId,
      )!['status'],
      'approved',
    );
    expect(find.text('Bekleyen istek yok'), findsOneWidget);

    await tester.tap(find.text('Ödül havuzu'));
    await tester.pumpAndSettle();
    final int before = client.mockStore.rewards.length;
    await tester.tap(find.text('Arkadaşla buluşma'));
    await settle(tester);

    expect(client.mockStore.rewards.length, before + 1);
    expect(tester.takeException(), isNull);
  });
}
