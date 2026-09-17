import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_header.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_step_enum.dart';

/// Every setup page numbers itself from the one list of steps.
///
/// The count and the name come from the step's place in the enum, so a page
/// cannot say "4/6" while the flow has seven steps.
void main() {
  testWidgets('each step shows its own name and its place of the total', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(AppAccentEnum.blue),
        locale: const Locale('tr'),
        localizationsDelegates: AppL10n.localizationsDelegates,
        supportedLocales: AppL10n.supportedLocales,
        home: const Scaffold(
          body: Column(
            children: <Widget>[
              AppSetupHeader(step: AppSetupStepEnum.account),
              AppSetupHeader(step: AppSetupStepEnum.child),
            ],
          ),
        ),
      ),
    );

    expect(AppSetupStepEnum.total, 6);
    expect(find.text('1/6'), findsOneWidget);
    expect(find.text('Kayıt'), findsOneWidget);
    expect(find.text('4/6'), findsOneWidget);
    expect(find.text('Çocuk'), findsOneWidget);
  });
}
