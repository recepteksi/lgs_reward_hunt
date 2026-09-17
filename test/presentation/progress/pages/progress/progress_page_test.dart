import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_child_header_use_case.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/read_child_snapshot_use_case.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/progress/cubit/progress/progress_cubit.dart';
import 'package:lgs_reward_hunt/application/progress/use_cases/load_progress_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/avatar/repositories/avatar_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/points/repositories/points_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_repository.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/progress/pages/progress/progress_page.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';

/// The progress tab for the demo child, scrolled end to end on a small phone
/// in dark mode.
void main() {
  final DateTime wednesday = DateTime(2026, 9, 16, 16);

  setUp(() async {
    final DioClient client = await mockBackend(clock: () => wednesday);
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': demoParent(client)['id']! as String,
      'session.activeChildId': client.mockStore.children.first['id']! as String,
    });
    const SessionRepository session = SessionRepository();
    getIt.registerFactory<ProgressCubit>(
      () => ProgressCubit(
        LoadChildHeaderUseCase(
          session,
          AccountRepository(client),
          AvatarRepository(client),
          ChildSnapshotCacheRepository(),
        ),
        LoadProgressUseCase(
          PointsRepository(client),
          TaskRepository(client),
          ChildSnapshotCacheRepository(),
        ),
        ReadChildSnapshotUseCase(ChildSnapshotCacheRepository()),
      )..clock = () => wednesday,
    );
  });

  tearDown(getIt.reset);

  testWidgets('shows level, week, month and badges without breaking', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(340, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.dark(AppAccentEnum.yellow),
        locale: const Locale('tr'),
        localizationsDelegates: AppL10n.localizationsDelegates,
        supportedLocales: AppL10n.supportedLocales,
        routerConfig: GoRouter(
          initialLocation: AppRoutePaths.progress.path(),
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutePaths.progress.pathEnd(),
              builder: (_, _) => const ProgressPage(),
            ),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('SEVİYE'), findsOneWidget);
    expect(find.text('Bu hafta'), findsOneWidget);

    for (int page = 0; page < 6; page++) {
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pump();
      expect(tester.takeException(), isNull, reason: 'page $page');
    }
    expect(find.text('Başarımlar'), findsOneWidget);
  });
}
