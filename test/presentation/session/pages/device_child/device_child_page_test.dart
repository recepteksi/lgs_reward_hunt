import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_device_choice_use_case.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_household_use_case.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/session/cubit/device_child/device_child_cubit.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/choose_device_child_use_case.dart';
import 'package:lgs_reward_hunt/domain/account/value_objects/child_profile_value_object.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/avatar/repositories/avatar_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/points/repositories/points_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:lgs_reward_hunt/presentation/session/pages/device_child/device_child_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';

/// The end of setup: which child this device opens on.
///
/// A parent of one child is never asked — the page goes straight to the map
/// with that child stored. A parent of two sees both with their balances, and
/// the one tapped is the one the device keeps.
void main() {
  late DioClient client;
  late String parentId;
  const SessionRepository session = SessionRepository();

  setUp(() async {
    client = await mockBackend();
    parentId = demoParent(client)['id']! as String;
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': parentId,
    });
    final AccountRepository accounts = AccountRepository(client);
    getIt.registerFactory<DeviceChildCubit>(
      () => DeviceChildCubit(
        LoadDeviceChoiceUseCase(
          LoadHouseholdUseCase(session, accounts, AvatarRepository(client)),
          PointsRepository(client),
          session,
        ),
        ChooseDeviceChildUseCase(session, ChildSnapshotCacheRepository()),
      ),
    );
  });

  tearDown(getIt.reset);

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.dark(AppAccentEnum.red),
        locale: const Locale('tr'),
        localizationsDelegates: AppL10n.localizationsDelegates,
        supportedLocales: AppL10n.supportedLocales,
        routerConfig: GoRouter(
          initialLocation: AppRoutePaths.deviceChild.path(),
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutePaths.deviceChild.pathEnd(),
              builder: (_, _) => const DeviceChildPage(),
            ),
            GoRoute(
              path: AppRoutePaths.home.pathEnd(),
              builder: (_, _) => const Text('map'),
            ),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  }

  testWidgets('one child is chosen without asking', (
    WidgetTester tester,
  ) async {
    await pump(tester);

    expect(find.text('map'), findsOneWidget);
    expect((await session.read()).right.activeChildId, isNotNull);
  });

  testWidgets('with two children the one tapped is kept', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(
      () => AccountRepository(client).addChild(
        parentId: parentId,
        profile: ChildProfileValueObject.create(
          name: 'Kerem',
          gradeLevel: 7,
          avatarId: 'av_e_01',
        ).right,
      ),
    );

    await pump(tester);

    expect(find.text('Bu cihazı kim kullanıyor?'), findsOneWidget);
    expect(find.text('7. sınıf · 0 puan'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Kerem'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('map'), findsOneWidget);
    final kerem = client.mockStore.children.firstWhere(
      (Map<String, Object?> c) => c['name'] == 'Kerem',
    );
    expect((await session.read()).right.activeChildId, kerem['id']);
  });
}
