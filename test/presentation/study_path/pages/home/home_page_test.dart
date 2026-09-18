import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/read_child_snapshot_use_case.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/study_path/cubit/home/home_cubit.dart';
import 'package:lgs_reward_hunt/application/study_path/use_cases/load_study_map_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/complete_task_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/avatar/repositories/avatar_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/exam/repositories/exam_schedule_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/points/repositories/points_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_repository.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';

/// The home map for the demo child, on a Wednesday in September.
///
/// The map opens on today with two of its tasks already done, the day sheet
/// peeks at them, and dragged open, ticking a pending one pays its points into
/// the balance — the loop the whole app is, end to end. The tap lands on the
/// row's left edge, clear of the parent button that rides above the bar.
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
    final TaskRepository tasks = TaskRepository(client);
    getIt.registerFactory<HomeCubit>(
      () => HomeCubit(
        LoadStudyMapUseCase(
          session,
          AccountRepository(client),
          AvatarRepository(client),
          PointsRepository(client),
          tasks,
          const ExamScheduleRepository(),
          ChildSnapshotCacheRepository(),
        ),
        CompleteTaskUseCase(tasks),
        ReadChildSnapshotUseCase(ChildSnapshotCacheRepository()),
      )..clock = () => wednesday,
    );
  });

  tearDown(getIt.reset);

  testWidgets('ticking today\'s task pays its points into the balance', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light(AppAccentEnum.blue),
        locale: const Locale('tr'),
        localizationsDelegates: AppL10n.localizationsDelegates,
        supportedLocales: AppL10n.supportedLocales,
        routerConfig: GoRouter(
          initialLocation: AppRoutePaths.home.path(),
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutePaths.home.pathEnd(),
              builder: (_, _) => const HomePage(),
            ),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Bugünün görevleri'), findsOneWidget);
    expect(find.text('Elif'), findsOneWidget);

    final String childId = client.mockStore.children.first['id']! as String;
    final int before = client.mockStore.balanceOf(childId);
    final pending = client.mockStore.tasks.firstWhere(
      (Map<String, Object?> t) =>
          t['childId'] == childId &&
          t['title'] == 'Çarpanlar ve katlar' &&
          DateTime.parse(t['scheduledAt']! as String).day == wednesday.day,
    );

    expect(pending['completedAt'], isNull);
    await tester.drag(find.text('Bugünün görevleri'), const Offset(0, -400));
    await tester.pumpAndSettle();
    await tester.tapAt(
      tester.getTopLeft(find.text('Çarpanlar ve katlar · 19:00 · 30 dk')) +
          const Offset(4, 4),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      client.mockStore.balanceOf(childId),
      before + (pending['points']! as int),
    );
  });
}
