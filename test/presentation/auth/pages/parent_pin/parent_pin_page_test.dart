import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/parent_pin/parent_pin_cubit.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/set_parent_pin_use_case.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/read_session_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/repositories/auth_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/parent_pin/parent_pin_page.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';
import '../../../../support/pump_page.dart';

/// Setting the parent PIN on a small phone: four digits, the same four again,
/// and setup moves on to the children.
void main() {
  setUp(() async {
    final client = await mockBackend();
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': demoParent(client)['id']! as String,
    });
    getIt.registerFactory<ParentPinCubit>(
      () => ParentPinCubit(
        const ReadSessionUseCase(SessionRepository()),
        SetParentPinUseCase(AuthRepository(client)),
      ),
    );
  });

  tearDown(getIt.reset);

  testWidgets('the same four digits twice set the PIN', (
    WidgetTester tester,
  ) async {
    await pumpPage(
      tester,
      at: AppRoutePaths.parentPin.path(),
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutePaths.parentPin.pathEnd(),
          builder: (_, _) => const ParentPinPage(),
        ),
        stubRoute(AppRoutePaths.childSetup.pathEnd(), 'children'),
      ],
    );
    expect(tester.takeException(), isNull);

    for (int pass = 0; pass < 2; pass++) {
      for (final String digit in <String>['2', '4', '6', '8']) {
        await tester.ensureVisible(find.text(digit));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(digit));
        await tester.pumpAndSettle();
        await tester.tap(find.text(digit));
        await tester.pump();
      }
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    }

    expect(find.text('children'), findsOneWidget);
  });
}
