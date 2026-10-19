import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/parent_gate/parent_gate_cubit.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/verify_parent_pin_use_case.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/read_session_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/repositories/auth_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/parent_gate/parent_gate_page.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';
import '../../../../support/pump_page.dart';

/// The door to the parent's page on a small phone: a wrong PIN says so and
/// stays, the right one opens the page.
void main() {
  setUp(() async {
    final client = await mockBackend();
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': demoParent(client)['id']! as String,
    });
    getIt.registerFactory<ParentGateCubit>(
      () => ParentGateCubit(
        const ReadSessionUseCase(SessionRepository()),
        VerifyParentPinUseCase(AuthRepository(client)),
      ),
    );
  });

  tearDown(getIt.reset);

  Future<void> enter(WidgetTester tester, String pin) async {
    for (final String digit in pin.split('')) {
      await tester.ensureVisible(find.text(digit));
      await tester.pumpAndSettle();
      await tester.tap(find.text(digit));
      await tester.pump();
    }
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  testWidgets('a wrong PIN stays, the right one opens the parent page', (
    WidgetTester tester,
  ) async {
    await pumpPage(
      tester,
      at: AppRoutePaths.parentGate.path(),
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutePaths.parentGate.pathEnd(),
          builder: (_, _) => const ParentGatePage(),
        ),
        stubRoute(AppRoutePaths.parent.pathEnd(), 'parent'),
      ],
    );
    expect(tester.takeException(), isNull);

    await enter(tester, '9999');
    expect(find.text('PIN hatalı, tekrar dene.'), findsOneWidget);

    await enter(tester, '1234');
    expect(find.text('parent'), findsOneWidget);
  });
}
