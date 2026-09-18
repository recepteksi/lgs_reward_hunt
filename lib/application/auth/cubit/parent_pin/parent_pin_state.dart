part of 'parent_pin_cubit.dart';

/// What the PIN screen is doing.
sealed class ParentPinState {
  const ParentPinState();
}

/// The keypad, with what has been typed so far.
///
/// [isRepeat] is the second pass, which the screen shows with different words
/// and nothing else — the keypad is identical, and it should be.
final class ParentPinEntering extends ParentPinState {
  const ParentPinEntering({required this.digits, required this.isRepeat});

  final String digits;

  final bool isRepeat;
}

/// The PIN is being stored.
final class ParentPinSubmitting extends ParentPinState {
  const ParentPinSubmitting();
}

/// The two passes did not match, or nobody is signed in.
final class ParentPinFailed extends ParentPinState {
  const ParentPinFailed(this.failure);

  final Failure failure;
}

/// The parent's side now has a lock on it.
final class ParentPinSet extends ParentPinState {
  const ParentPinSet();
}
