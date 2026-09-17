import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/sign_up_use_case.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/save_session_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/session/value_objects/session_value_object.dart';

part 'password_state.dart';

/// Where the account is actually created.
///
/// The screen before it collected a name and an email; this one adds the
/// password and makes the parent. Doing it here rather than a step earlier is
/// what lets the password screen own the checklist — the three rules are the
/// reason this step exists at all.
///
/// The session is written as soon as the parent exists, so an app killed
/// between here and the PIN screen comes back to setup rather than to a login
/// form for an account that already exists.
@injectable
final class PasswordCubit extends Cubit<PasswordState> {
  PasswordCubit(this._signUp, this._saveSession)
    : super(const PasswordEditing());

  final SignUpUseCase _signUp;

  final SaveSessionUseCase _saveSession;

  Future<void> submit({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const PasswordSubmitting());

    final result = await _signUp(name: name, email: email, password: password);
    if (isClosed) return;

    switch (result) {
      case Left(:final value):
        emit(PasswordFailed(value));
      case Right(:final value):
        await _saveSession(
          SessionValueObject(parentId: value.id, activeChildId: null),
        );
        if (isClosed) return;
        emit(PasswordCreated(value));
    }
  }
}
