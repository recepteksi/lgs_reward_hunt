part of 'password_cubit.dart';

/// What the password screen is doing.
sealed class PasswordState {
  const PasswordState();
}

/// The two fields and the checklist, waiting.
final class PasswordEditing extends PasswordState {
  const PasswordEditing();
}

/// The account is being created.
final class PasswordSubmitting extends PasswordState {
  const PasswordSubmitting();
}

/// It could not be — the email is taken, or the rules were not met.
final class PasswordFailed extends PasswordState {
  const PasswordFailed(this.failure);

  final Failure failure;
}

/// The parent exists and the session has been written.
final class PasswordCreated extends PasswordState {
  const PasswordCreated(this.parent);

  final ParentEntity parent;
}
