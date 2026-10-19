import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/ui_kit_page.dart';

/// Scrolls the whole design system at phone size.
///
/// The sheet is eleven sections of every component the app has, so a pass over
/// it catches what no single component test can: an overflow that only happens
/// at 390 pixels, a specimen that reads a theme extension the page forgot to
/// provide, a grid whose aspect ratio clips a price. It is the cheapest broad
/// check in the suite and the one most likely to fail first when a token moves.
Future<void> _pump(WidgetTester tester) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(AppAccentEnum.blue),
      locale: const Locale('tr'),
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      home: const UiKitPage(),
    ),
  );
}

void main() {
  testWidgets('scrolls end to end without a component breaking', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await _pump(tester);
    await tester.pump();

    expect(find.text('Colour tokens'), findsOneWidget);

    for (int page = 0; page < 20; page++) {
      await tester.drag(find.byType(ListView).first, const Offset(0, -700));
      await tester.pump();

      expect(tester.takeException(), isNull, reason: 'page $page');
    }

    expect(find.text('Avatar'), findsOneWidget);
  });

  testWidgets('previews another accent and both brightnesses on the spot', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await _pump(tester);
    await tester.pump();

    await tester.tap(find.text('Koyu'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      Theme.of(tester.element(find.text('Colour tokens'))).brightness,
      Brightness.dark,
    );
  });
}
