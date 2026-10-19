import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/debug/widgets/debug_accounts_overlay.dart';

/// The dev button opens the accounts as they are when it is tapped, and closes.
void main() {
  testWidgets('lists the accounts read at the moment it is opened', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final List<Map<String, String>> accounts = <Map<String, String>>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(AppAccentEnum.blue),
        builder: (BuildContext context, Widget? child) =>
            DebugAccountsOverlay(readAccounts: () => accounts, child: child!),
        home: const SizedBox.shrink(),
      ),
    );

    accounts.add(<String, String>{
      DebugAccountsOverlay.currentMarker: 'true',
      'email': 'demo@example.com',
      'password': 'secret123',
    });
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(find.textContaining('demo@example.com'), findsOneWidget);
    expect(find.textContaining('secret123'), findsOneWidget);
    expect(
      find.textContaining(DebugAccountsOverlay.currentMarker),
      findsNothing,
    );

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(find.textContaining('secret123'), findsNothing);
  });
}
