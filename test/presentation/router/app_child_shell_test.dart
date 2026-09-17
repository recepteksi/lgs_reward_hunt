import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_child_header_use_case.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/read_child_snapshot_use_case.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/profile/cubit/profile/profile_cubit.dart';
import 'package:lgs_reward_hunt/application/profile/use_cases/load_profile_use_case.dart';
import 'package:lgs_reward_hunt/application/progress/cubit/progress/progress_cubit.dart';
import 'package:lgs_reward_hunt/application/progress/use_cases/load_progress_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/cubit/rewards/rewards_cubit.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/get_reward_shop_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/request_reward_use_case.dart';
import 'package:lgs_reward_hunt/application/settings/cubit/appearance/appearance_cubit.dart';
import 'package:lgs_reward_hunt/application/settings/use_cases/read_appearance_use_case.dart';
import 'package:lgs_reward_hunt/application/settings/use_cases/save_appearance_use_case.dart';
import 'package:lgs_reward_hunt/application/study_path/cubit/home/home_cubit.dart';
import 'package:lgs_reward_hunt/application/study_path/use_cases/load_study_map_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/complete_task_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/avatar/repositories/avatar_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/exam/repositories/exam_schedule_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/points/repositories/points_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/settings/repositories/appearance_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_repository.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_bottom_nav.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_loading_view.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:lgs_reward_hunt/presentation/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/mock_backend.dart';
import '../../support/pump_page.dart';

/// Switching child tabs keeps the frame on screen.
///
/// The tabs were separate routes, each drawing its own bar, so a switch
/// rebuilt the whole screen and passed through a bare loading page. Now they
/// share one shell: the bar is never rebuilt away, the tabs are already
/// loaded, and a tab brought back picks up points earned elsewhere.
void main() {
  final DateTime wednesday = DateTime(2026, 9, 16, 16);
  late DioClient client;
  late AppearanceCubit appearance;

  setUp(() async {
    client = await mockBackend(clock: () => wednesday);
    final String childId = client.mockStore.children.first['id']! as String;
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': demoParent(client)['id']! as String,
      'session.activeChildId': childId,
    });
    const SessionRepository session = SessionRepository();
    final AccountRepository accounts = AccountRepository(client);
    final AvatarRepository avatars = AvatarRepository(client);
    final PointsRepository points = PointsRepository(client);
    final TaskRepository tasks = TaskRepository(client);
    final RewardRepository rewards = RewardRepository(client);
    final LoadChildHeaderUseCase header = LoadChildHeaderUseCase(
      session,
      accounts,
      avatars,
      ChildSnapshotCacheRepository(),
    );
    const AppearanceRepository settings = AppearanceRepository();
    appearance = AppearanceCubit(
      const ReadAppearanceUseCase(settings),
      const SaveAppearanceUseCase(settings),
    );

    getIt
      ..registerFactory<HomeCubit>(
        () => HomeCubit(
          LoadStudyMapUseCase(
            session,
            accounts,
            avatars,
            points,
            tasks,
            const ExamScheduleRepository(),
            ChildSnapshotCacheRepository(),
          ),
          CompleteTaskUseCase(tasks),
          ReadChildSnapshotUseCase(ChildSnapshotCacheRepository()),
        )..clock = () => wednesday,
      )
      ..registerFactory<RewardsCubit>(
        () => RewardsCubit(
          header,
          GetRewardShopUseCase(
            accounts,
            points,
            rewards,
            ChildSnapshotCacheRepository(),
          ),
          RequestRewardUseCase(rewards),
          ReadChildSnapshotUseCase(ChildSnapshotCacheRepository()),
        ),
      )
      ..registerFactory<ProgressCubit>(
        () => ProgressCubit(
          header,
          LoadProgressUseCase(points, tasks, ChildSnapshotCacheRepository()),
          ReadChildSnapshotUseCase(ChildSnapshotCacheRepository()),
        )..clock = () => wednesday,
      )
      ..registerFactory<ProfileCubit>(
        () => ProfileCubit(
          LoadProfileUseCase(
            header,
            LoadProgressUseCase(points, tasks, ChildSnapshotCacheRepository()),
            accounts,
            const ExamScheduleRepository(),
          ),
          ReadChildSnapshotUseCase(ChildSnapshotCacheRepository()),
        )..clock = () => wednesday,
      );
  });

  tearDown(getIt.reset);

  testWidgets('a tab switch keeps the bar and never shows a loading page', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = smallPhone;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<AppearanceCubit>.value(
        value: appearance,
        child: MaterialApp.router(
          theme: AppTheme.light(AppAccentEnum.blue),
          locale: const Locale('tr'),
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          routerConfig: AppRouter.build(AppRoutePaths.home.path()),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    for (final String tab in <String>['Ödüller', 'İlerleme', 'Profil']) {
      final Element bar = tester.element(find.byType(AppBottomNav));
      await tester.tap(find.text(tab));
      await tester.pump();

      expect(find.byType(AppLoadingView), findsNothing);
      expect(tester.element(find.byType(AppBottomNav)), same(bar));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('a swipe moves to the next tab and the bar follows', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = smallPhone;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<AppearanceCubit>.value(
        value: appearance,
        child: MaterialApp.router(
          theme: AppTheme.light(AppAccentEnum.blue),
          locale: const Locale('tr'),
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          routerConfig: AppRouter.build(AppRoutePaths.progress.path()),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    await tester.fling(
      find.byType(PageView),
      const Offset(-300, 0),
      1000,
      warnIfMissed: false,
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(
      tester.widget<AppBottomNav>(find.byType(AppBottomNav)).currentTab,
      AppNavTabEnum.profile,
    );
    expect(find.byType(AppLoadingView), findsNothing);
  });
}
