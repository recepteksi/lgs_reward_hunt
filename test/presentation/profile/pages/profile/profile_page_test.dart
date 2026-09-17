import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_child_header_use_case.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/read_child_snapshot_use_case.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/profile/cubit/profile/profile_cubit.dart';
import 'package:lgs_reward_hunt/application/profile/use_cases/load_profile_use_case.dart';
import 'package:lgs_reward_hunt/application/progress/use_cases/load_progress_use_case.dart';
import 'package:lgs_reward_hunt/application/settings/cubit/appearance/appearance_cubit.dart';
import 'package:lgs_reward_hunt/application/settings/use_cases/read_appearance_use_case.dart';
import 'package:lgs_reward_hunt/application/settings/use_cases/save_appearance_use_case.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_header_read_model.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_snapshot_read_model.dart';
import 'package:lgs_reward_hunt/domain/settings/enums/accent_choice_enum.dart';
import 'package:lgs_reward_hunt/domain/settings/enums/theme_choice_enum.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/avatar/repositories/avatar_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/exam/repositories/exam_schedule_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/points/repositories/points_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/settings/repositories/appearance_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_repository.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_loading_view.dart';
import 'package:lgs_reward_hunt/presentation/profile/pages/profile/profile_page.dart';
import 'package:lgs_reward_hunt/presentation/profile/pages/profile/widgets/profile_skeleton.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';

/// The profile tab for the demo child.
///
/// It shows the child, their parent and the next exam, and the appearance card
/// changes the app's setting — dark mode and the pink accent both land in the
/// shell's Cubit.
void main() {
  final DateTime wednesday = DateTime(2026, 9, 16, 16);
  late AppearanceCubit appearance;
  late DioClient client;
  late ChildSnapshotCacheRepository snapshots;

  setUp(() async {
    client = await mockBackend(clock: () => wednesday);
    snapshots = ChildSnapshotCacheRepository();
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': demoParent(client)['id']! as String,
      'session.activeChildId': client.mockStore.children.first['id']! as String,
    });
    const SessionRepository session = SessionRepository();
    const AppearanceRepository settings = AppearanceRepository();
    appearance = AppearanceCubit(
      const ReadAppearanceUseCase(settings),
      const SaveAppearanceUseCase(settings),
    );
    final AccountRepository accounts = AccountRepository(client);
    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(
        LoadProfileUseCase(
          LoadChildHeaderUseCase(
            session,
            accounts,
            AvatarRepository(client),
            snapshots,
          ),
          LoadProgressUseCase(
            PointsRepository(client),
            TaskRepository(client),
            snapshots,
          ),
          accounts,
          const ExamScheduleRepository(),
        ),
        ReadChildSnapshotUseCase(snapshots),
      )..clock = () => wednesday,
    );
  });

  tearDown(getIt.reset);

  testWidgets('shows the child and changes the appearance setting', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
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
          routerConfig: GoRouter(
            initialLocation: AppRoutePaths.profile.path(),
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutePaths.profile.pathEnd(),
                builder: (_, _) => const ProfilePage(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Ayşe'), findsOneWidget);
    expect(find.text('13 Haziran 2027'), findsOneWidget);

    await tester.tap(find.text('Koyu'));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Pembe'));
    await tester.pump();

    expect(appearance.state.settings.theme, ThemeChoiceEnum.dark);
    expect(appearance.state.settings.accent, AccentChoiceEnum.pink);
  });

  testWidgets('a known child opens the profile at once, with the bar', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final Map<String, Object?> row = client.mockStore.children.first;
    snapshots.write(
      ChildSnapshotReadModel.empty
          .withHeader(
            ChildHeaderReadModel(
              child: ChildEntity.create(
                id: row['id']! as String,
                parentId: row['parentId']! as String,
                name: row['name']! as String,
              ).right,
              avatar: null,
            ),
          )
          .withBalance(480),
    );

    await tester.pumpWidget(
      BlocProvider<AppearanceCubit>.value(
        value: appearance,
        child: MaterialApp.router(
          theme: AppTheme.light(AppAccentEnum.blue),
          locale: const Locale('tr'),
          localizationsDelegates: AppL10n.localizationsDelegates,
          supportedLocales: AppL10n.supportedLocales,
          routerConfig: GoRouter(
            initialLocation: AppRoutePaths.profile.path(),
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutePaths.profile.pathEnd(),
                builder: (_, _) => const ProfilePage(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AppLoadingView), findsNothing);
    expect(find.byType(ProfileSkeleton), findsOneWidget);
    expect(find.text(row['name']! as String), findsWidgets);
    expect(find.text('480'), findsWidgets);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileSkeleton), findsNothing);
  });
}
