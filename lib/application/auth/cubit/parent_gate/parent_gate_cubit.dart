import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/verify_parent_pin_use_case.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/read_session_use_case.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/rules/auth_rules.dart';

part 'parent_gate_state.dart';

/// The PIN between the child's tabs and the parent's side.
///
/// It holds the digits, because the keypad is not a text field. The fourth
/// digit checks the code at once — there is no "enter" to press on a keypad
/// meant for a thumb. A wrong code clears the dots and says so; the right one
/// ends in [ParentGateOpened], and the page lets the parent in.
@injectable
final class ParentGateCubit extends Cubit<ParentGateState> {
  ParentGateCubit(this._readSession, this._verify)
    : super(const ParentGateEntering(CharConstants.empty));

  final ReadSessionUseCase _readSession;

  final VerifyParentPinUseCase _verify;

  void press(String digit) {
    final ParentGateState current = state;
    if (current is ParentGateChecking || current is ParentGateOpened) return;
    final String digits = current.digits + digit;
    if (digits.length < AuthRules.pinLength) {
      emit(ParentGateEntering(digits));
      return;
    }
    _check(digits);
  }

  void backspace() {
    final ParentGateState current = state;
    if (current is! ParentGateEntering || current.digits.isEmpty) return;
    emit(
      ParentGateEntering(
        current.digits.substring(
          ValueConstants.zero,
          current.digits.length - ValueConstants.one,
        ),
      ),
    );
  }

  Future<void> _check(String digits) async {
    emit(ParentGateChecking(digits));

    final session = await _readSession();
    if (isClosed) return;
    final String? parentId = session.fold((_) => null, (s) => s.parentId);
    if (parentId == null) {
      emit(
        const ParentGateWrong(
          UnauthorizedFailure(FailureMessageKey.notSignedIn),
        ),
      );
      return;
    }

    final result = await _verify(parentId: parentId, pin: digits);
    if (isClosed) return;

    emit(switch (result) {
      Left(:final value) => ParentGateWrong(value),
      Right(:final value) =>
        value
            ? const ParentGateOpened()
            : const ParentGateWrong(
                ValidationFailure(FailureMessageKey.pinWrong),
              ),
    });
  }
}
