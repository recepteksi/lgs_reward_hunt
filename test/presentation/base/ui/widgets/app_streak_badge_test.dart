import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/badge/app_streak_badge.dart';

Future<void> _pump(WidgetTester tester, int days) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(AppAccentEnum.blue),
      locale: const Locale('tr'),
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      home: Scaffold(body: AppStreakBadge(days: days)),
    ),
  );
}

void main() {
  group('AppStreakBadge', () {
    testWidgets('says nothing on the first day, because one day is not a run', (
      WidgetTester tester,
    ) async {
      await _pump(tester, 1);

      expect(find.byType(Text), findsNothing);
    });

    testWidgets('counts the days once there are two or more', (
      WidgetTester tester,
    ) async {
      await _pump(tester, 7);

      expect(find.text('7 gün'), findsOneWidget);
    });
  });
}
