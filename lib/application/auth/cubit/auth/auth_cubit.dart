import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/open_session_use_case.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/platform_sign_in_use_case.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/sign_in_use_case.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/enums/auth_provider_enum.dart';

part 'auth_state.dart';

/// The first screen with a decision on it: new account, or an old one.
///
/// The two halves take different paths on purpose. Signing IN can finish here —
/// there is an account, so the session is written and the app opens. Signing UP
/// cannot: the password is a screen of its own, with its own rules and its own
/// checklist, so this Cubit only carries the name and the email forward and
/// lets that screen create the account.
///
/// [continueWith] is Google or Apple: a returning parent is signed in like an
/// email sign-in; a new one goes on to set a PIN ([AuthNeedsPin]); a sheet the
/// parent closed returns to the form as if nothing happened. Every sign-in
/// opens the session through `OpenSessionUseCase`, on the household's first
/// child, so a returning family is not sent back through setup.
///
/// It emits [AuthNeedsPassword] rather than navigating, because a Cubit that
/// knew about routes would be a Cubit that could not be tested without one.
@injectable
final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._signIn, this._platformSignIn, this._openSession)
    : super(const AuthEditing(isSignUp: true));

  final SignInUseCase _signIn;

  final PlatformSignInUseCase _platformSignIn;

  final OpenSessionUseCase _openSession;

  bool _isSignUp = true;

  void chooseSignUp() {
    _isSignUp = true;
    emit(const AuthEditing(isSignUp: true));
  }

  void chooseSignIn() {
    _isSignUp = false;
    emit(const AuthEditing(isSignUp: false));
  }

  void submitSignUp({required String name, required String email}) =>
      emit(AuthNeedsPassword(name: name, email: email));

  Future<void> submitSignIn({
    required String email,
    required String password,
  }) async {
    emit(const AuthSubmitting());

    final result = await _signIn(email: email, password: password);
    if (isClosed) return;

    switch (result) {
      case Left(:final value):
        emit(AuthFailed(value));
      case Right(:final value):
        await _open(value.id);
    }
  }

  Future<void> continueWith(AuthProviderEnum provider) async {
    emit(const AuthSubmitting());

    final result = await _platformSignIn(provider);
    if (isClosed) return;

    switch (result) {
      case Left(:final value)
          when value.messageKey == FailureMessageKey.signInCancelled:
        emit(AuthEditing(isSignUp: _isSignUp));
      case Left(:final value):
        emit(AuthFailed(value));
      case Right(:final value) when value.isNewAccount:
        final session = await _openSession(value.parent.id);
        if (isClosed) return;
        emit(session.isLeft ? AuthFailed(session.left) : const AuthNeedsPin());
      case Right(:final value):
        await _open(value.parent.id);
    }
  }

  Future<void> _open(String parentId) async {
    final session = await _openSession(parentId);
    if (isClosed) return;

    emit(switch (session) {
      Left(:final value) => AuthFailed(value),
      Right(:final value) => AuthSignedIn(hasChild: value.hasChild),
    });
  }
}
