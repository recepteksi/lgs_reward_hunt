import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/password/password_cubit.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/sign_up_use_case.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/save_session_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/repositories/auth_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/password/password_page.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:lgs_reward_hunt/presentation/router/arguments/password_arguments_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/mock_backend.dart';
import '../../../../support/pump_page.dart';

/// Setting the password on a small phone: a password that meets every rule,
/// typed twice, creates the account and moves on to the PIN.
void main() {
  setUp(() async {
    final client = await mockBackend(withDemoHousehold: false);
    SharedPreferences.setMockInitialValues(<String, Object>{});
    getIt.registerFactory<PasswordCubit>(
      () => PasswordCubit(
        SignUpUseCase(AuthRepository(client)),
        const SaveSessionUseCase(SessionRepository()),
      ),
    );
  });

  tearDown(getIt.reset);

  testWidgets('a strong password typed twice opens the PIN step', (
    WidgetTester tester,
  ) async {
    await pumpPage(
      tester,
      at: AppRoutePaths.password.path(),
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutePaths.password.pathEnd(),
          builder: (_, _) => const PasswordPage(
            arguments: PasswordArgumentsModel(
              name: 'Ayşe Yılmaz',
              email: 'yeni@ornek.com',
            ),
          ),
        ),
        stubRoute(AppRoutePaths.parentPin.pathEnd(), 'pin'),
      ],
    );
    expect(tester.takeException(), isNull);

    await tester.enterText(find.byType(TextField).at(0), 'Guclu123');
    await tester.enterText(find.byType(TextField).at(1), 'Guclu123');
    await tester.ensureVisible(find.text('Devam et'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Devam et'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('pin'), findsOneWidget);
  });
}
