import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_child_header_use_case.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/read_child_snapshot_use_case.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/reward/cubit/rewards/rewards_cubit.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/get_reward_shop_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/request_reward_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/avatar/repositories/avatar_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/points/repositories/points_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/rewards/rewards_page.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';

/// The rewards tab for the demo child.
///
/// The shop shows the balance, a request already waiting on a parent, and a
/// reward the balance covers; asking for it holds its price, announces the
/// request, and turns its card to waiting.
void main() {
  late DioClient client;
  late String childId;

  setUp(() async {
    client = await mockBackend();
    childId = client.mockStore.children.first['id']! as String;
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': demoParent(client)['id']! as String,
      'session.activeChildId': childId,
    });
    const SessionRepository session = SessionRepository();
    final AccountRepository accounts = AccountRepository(client);
    final RewardRepository rewards = RewardRepository(client);
    getIt.registerFactory<RewardsCubit>(
      () => RewardsCubit(
        LoadChildHeaderUseCase(
          session,
          accounts,
          AvatarRepository(client),
          ChildSnapshotCacheRepository(),
        ),
        GetRewardShopUseCase(
          accounts,
          PointsRepository(client),
          rewards,
          ChildSnapshotCacheRepository(),
        ),
        RequestRewardUseCase(rewards),
        ReadChildSnapshotUseCase(ChildSnapshotCacheRepository()),
      ),
    );
  });

  tearDown(getIt.reset);

  testWidgets('asking for an affordable reward holds its price', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final int before = client.mockStore.balanceOf(childId);
    final affordable = client.mockStore.rewards
        .where(
          (Map<String, Object?> r) =>
              (r['cost']! as int) <= before &&
              !client.mockStore.redemptions.any(
                (Map<String, Object?> q) =>
                    q['rewardId'] == r['id'] && q['status'] == 'pending',
              ),
        )
        .first;

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light(AppAccentEnum.pink),
        locale: const Locale('tr'),
        localizationsDelegates: AppL10n.localizationsDelegates,
        supportedLocales: AppL10n.supportedLocales,
        routerConfig: GoRouter(
          initialLocation: AppRoutePaths.rewards.path(),
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutePaths.rewards.pathEnd(),
              builder: (_, _) => const RewardsPage(),
            ),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('ÖDÜL HAVUZU'), findsOneWidget);
    expect(find.text('Onay bekliyor'), findsWidgets);

    await tester.tap(find.text(affordable['name']! as String).first);
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(
      client.mockStore.balanceOf(childId),
      before - (affordable['cost']! as int),
    );
    expect(
      find.text('${affordable['name']} isteği gönderildi.'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
