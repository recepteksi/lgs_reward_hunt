import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/set_parent_pin_use_case.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/read_session_use_case.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/rules/auth_rules.dart';

part 'parent_pin_state.dart';

/// The two-pass PIN: set it, then set it again.
///
/// The Cubit holds the digits because the keypad is not a text field — there is
/// no controller to read, and the four dots are drawn from this state. It also
/// holds which pass we are on, which is the only reason the screen can say
/// "tekrar gir" without knowing anything about how a PIN is confirmed.
///
/// A second entry that does not match sends the whole thing back to the first
/// pass. Correcting one digit of a code you cannot see is worse than typing
/// four again.
///
/// [stepBack] is the back arrow: on the second pass it returns to the first and
/// answers true, and on the first it answers false, leaving the page to decide
/// where back leads.
@injectable
final class ParentPinCubit extends Cubit<ParentPinState> {
  ParentPinCubit(this._readSession, this._setPin)
    : super(
        const ParentPinEntering(digits: CharConstants.empty, isRepeat: false),
      );

  final ReadSessionUseCase _readSession;

  final SetParentPinUseCase _setPin;

  String _first = CharConstants.empty;

  void press(String digit) {
    final ParentPinState current = state;
    if (current is! ParentPinEntering) return;
    if (current.digits.length >= AuthRules.pinLength) return;

    _advance(current, current.digits + digit);
  }

  void backspace() {
    final ParentPinState current = state;
    if (current is! ParentPinEntering || current.digits.isEmpty) return;

    emit(
      ParentPinEntering(
        digits: current.digits.substring(
          ValueConstants.zero,
          current.digits.length - ValueConstants.one,
        ),
        isRepeat: current.isRepeat,
      ),
    );
  }

  Future<void> _advance(ParentPinEntering current, String digits) async {
    if (digits.length < AuthRules.pinLength) {
      emit(ParentPinEntering(digits: digits, isRepeat: current.isRepeat));
      return;
    }

    if (!current.isRepeat) {
      _first = digits;
      emit(
        const ParentPinEntering(digits: CharConstants.empty, isRepeat: true),
      );
      return;
    }

    emit(const ParentPinSubmitting());

    final session = await _readSession();
    if (isClosed) return;

    final String? parentId = switch (session) {
      Left() => null,
      Right(:final value) => value.parentId,
    };
    if (parentId == null) {
      emit(
        const ParentPinFailed(
          UnauthorizedFailure(FailureMessageKey.notSignedIn),
        ),
      );
      return;
    }

    final result = await _setPin(
      parentId: parentId,
      first: _first,
      second: digits,
    );
    if (isClosed) return;

    switch (result) {
      case Left(:final value):
        _first = CharConstants.empty;
        emit(ParentPinFailed(value));
      case Right():
        emit(const ParentPinSet());
    }
  }

  bool stepBack() {
    final ParentPinState current = state;
    if (current is! ParentPinEntering || !current.isRepeat) return false;

    restart();
    return true;
  }

  void restart() {
    _first = CharConstants.empty;
    emit(const ParentPinEntering(digits: CharConstants.empty, isRepeat: false));
  }
}
