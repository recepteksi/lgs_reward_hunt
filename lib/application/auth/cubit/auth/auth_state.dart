part of 'auth_cubit.dart';

/// What the account screen is doing.
sealed class AuthState {
  const AuthState();
}

/// The form, waiting. [isSignUp] is which of the two tabs is showing.
final class AuthEditing extends AuthState {
  const AuthEditing({required this.isSignUp});

  final bool isSignUp;
}

/// The credentials are with the server.
final class AuthSubmitting extends AuthState {
  const AuthSubmitting();
}

/// The server said no, or the email never looked like one.
final class AuthFailed extends AuthState {
  const AuthFailed(this.failure);

  final Failure failure;
}

/// A returning parent is signed in; [hasChild] decides whether the app opens
/// on the map or on the child setup step.
final class AuthSignedIn extends AuthState {
  const AuthSignedIn({required this.hasChild});

  final bool hasChild;
}

/// A new parent's account was opened with Google or Apple; they set their PIN
/// next, as an email sign-up does after its password.
final class AuthNeedsPin extends AuthState {
  const AuthNeedsPin();
}

/// A new parent, on the way to choosing a password.
final class AuthNeedsPassword extends AuthState {
  const AuthNeedsPassword({required this.name, required this.email});

  final String name;

  final String email;
}
