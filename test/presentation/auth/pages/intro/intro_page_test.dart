import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/intro/intro_page.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';

/// Walks the intro at phone size, in both brightnesses.
///
/// The slides are pictures sized by the space they are given, so the failure
/// worth catching is an overflow on a short phone, or a last slide whose button
/// still says "Devam" and never lets the parent out. The account route is a
/// stub here: what is being checked is that the intro leaves, not what it
/// leaves for.
Future<void> _pump(
  WidgetTester tester, {
  required Size size,
  required ThemeData theme,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp.router(
      theme: theme,
      locale: const Locale('tr'),
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      routerConfig: GoRouter(
        initialLocation: AppRoutePaths.intro.path(),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.intro.pathEnd(),
            builder: (_, _) => const IntroPage(),
          ),
          GoRoute(
            path: AppRoutePaths.auth.pathEnd(),
            builder: (_, _) => const Text('auth'),
          ),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('continues through three slides and then leaves for sign-up', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      size: const Size(360, 640),
      theme: AppTheme.light(AppAccentEnum.blue),
    );

    expect(find.text('Görevleri bitir,\nhazineyi aç.'), findsOneWidget);

    await tester.tap(find.text('Devam'));
    await tester.pumpAndSettle();
    expect(find.text('Bugünün görevleri'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Devam'));
    await tester.pumpAndSettle();
    expect(find.text('Onay bekliyor'), findsOneWidget);
    expect(find.text('Devam'), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Hesap oluştur'));
    await tester.pumpAndSettle();
    expect(find.text('auth'), findsOneWidget);
  });

  testWidgets('skip leaves from the first slide', (WidgetTester tester) async {
    await _pump(
      tester,
      size: const Size(360, 640),
      theme: AppTheme.light(AppAccentEnum.blue),
    );

    await tester.tap(find.text('Geç'));
    await tester.pumpAndSettle();

    expect(find.text('auth'), findsOneWidget);
  });

  testWidgets('fits every slide on a short phone in dark mode', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      size: const Size(320, 568),
      theme: AppTheme.dark(AppAccentEnum.pink),
    );

    for (int slide = 0; slide < 3; slide++) {
      expect(tester.takeException(), isNull, reason: 'slide $slide');
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
    }
  });
}
