import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/parent_pin/parent_pin_cubit.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/set_parent_pin_use_case.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/read_session_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/repositories/auth_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';

import '../../support/mock_backend.dart';

/// The PIN page's back arrow, as the design has it.
///
/// On the second pass back returns to the first and stays on the page; on the
/// first pass it is not the Cubit's to handle, and the page leaves.
void main() {
  Future<ParentPinCubit> cubit() async => ParentPinCubit(
    const ReadSessionUseCase(SessionRepository()),
    SetParentPinUseCase(
      AuthRepository(await mockBackend(withDemoHousehold: false)),
    ),
  );

  test('back on the first pass leaves the page', () async {
    expect((await cubit()).stepBack(), isFalse);
  });

  test('back on the second pass returns to the first', () async {
    final ParentPinCubit pin = await cubit();
    for (final String digit in <String>['1', '2', '3', '4']) {
      pin.press(digit);
    }

    expect((pin.state as ParentPinEntering).isRepeat, isTrue);
    expect(pin.stepBack(), isTrue);
    expect((pin.state as ParentPinEntering).isRepeat, isFalse);
  });
}
