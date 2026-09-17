import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/account/cubit/child_form/child_form_cubit.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/add_child_use_case.dart';
import 'package:lgs_reward_hunt/application/avatar/use_cases/load_avatars_use_case.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/avatar/repositories/avatar_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_form/child_form_page.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';

/// Adding a child through the form, against the mock backend.
///
/// The catalogue loads, the boy tab narrows it, the save button waits for a
/// name and a face, and a saved child closes the form back onto the list.
void main() {
  late DioClient client;

  setUp(() async {
    client = await mockBackend();
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': demoParent(client)['id']! as String,
    });
    client.mockStore.children.clear();
    const SessionRepository session = SessionRepository();
    getIt.registerFactory<ChildFormCubit>(
      () => ChildFormCubit(
        LoadAvatarsUseCase(AvatarRepository(client)),
        AddChildUseCase(session, AccountRepository(client)),
      ),
    );
  });

  tearDown(getIt.reset);

  testWidgets('saves a child once there is a name and a face', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final GoRouter router = GoRouter(
      initialLocation: AppRoutePaths.childSetup.path(),
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutePaths.childSetup.pathEnd(),
          builder: (_, _) => const Text('list'),
          routes: <RouteBase>[
            GoRoute(
              path: AppRoutePaths.childForm.pathEnd(),
              builder: (_, _) => const ChildFormPage(),
            ),
          ],
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
    router.push(AppRoutePaths.childForm.path());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Avatar kataloğu sunucudan yükleniyor…'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Defne'), findsOneWidget);
    expect(find.bySemanticsLabel('Kerem'), findsNothing);

    await tester.tap(find.text('Erkek'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Kerem'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Kerem'));
    await tester.pumpAndSettle();
    expect(find.text('Seçilen avatar: Kerem'), findsOneWidget);

    await tester.tap(find.text('Çocuğu ekle'));
    await tester.pumpAndSettle();
    expect(find.text('list'), findsNothing, reason: 'no name yet');

    await tester.enterText(find.byType(TextField), 'Kerem');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Çocuğu ekle'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('list'), findsOneWidget);
    expect(client.mockStore.children.single['avatarId'], 'av_e_01');
  });
}
