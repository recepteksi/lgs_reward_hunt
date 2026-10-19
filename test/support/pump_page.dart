import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// The smallest phone a page test is held to: 360 × 640 logical pixels.
///
/// A layout that only fits a large phone has already shipped here twice (task
/// setup, the top bar); `check_structure` requires every page test to pump at
/// a width no larger than this.
const Size smallPhone = Size(360, 640);

/// Pumps [routes] in the app's theme and locale, starting at [at], on
/// [smallPhone], and lets the first load settle.
///
/// Every route a page can leave to is passed in, usually as a stub that
/// shows its own name, so a test can assert where the page went.
Future<GoRouter> pumpPage(
  WidgetTester tester, {
  required String at,
  required List<RouteBase> routes,
}) async {
  tester.view.physicalSize = smallPhone;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final GoRouter router = GoRouter(initialLocation: at, routes: routes);
  await tester.pumpWidget(
    MaterialApp.router(
      theme: AppTheme.light(AppAccentEnum.blue),
      locale: const Locale('tr'),
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      routerConfig: router,
    ),
  );
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
  return router;
}

/// A route that shows only [name] — a stand-in for where a page navigates.
GoRoute stubRoute(String path, String name) => GoRoute(
  path: path,
  builder: (_, _) => Scaffold(body: Text(name)),
);
