import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/badge/app_points_badge.dart';

Future<void> _pump(WidgetTester tester, Locale locale, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(AppAccentEnum.blue),
      locale: locale,
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('AppPointsBadge', () {
    testWidgets('groups a balance the way Turkish writes one', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const Locale('tr'),
        const AppPointsBadge(points: 1240),
      );

      expect(find.text('1.240'), findsOneWidget);
    });

    testWidgets('reads on the amber in both of its weights', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        const Locale('tr'),
        const Column(
          children: <Widget>[
            AppPointsBadge(points: 30),
            AppPointsBadge.prominent(points: 30),
          ],
        ),
      );

      expect(find.text('30'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  });
}
