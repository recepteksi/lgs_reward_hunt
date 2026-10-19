part of 'parent_gate_cubit.dart';

/// What the PIN gate is showing. [digits] is what is typed so far.
sealed class ParentGateState {
  const ParentGateState(this.digits);

  final String digits;
}

/// The keypad, with what has been typed.
final class ParentGateEntering extends ParentGateState {
  const ParentGateEntering(super.digits);
}

/// The code is being checked.
final class ParentGateChecking extends ParentGateState {
  const ParentGateChecking(super.digits);
}

/// The code was wrong, or could not be checked; the dots are clear again.
final class ParentGateWrong extends ParentGateState {
  const ParentGateWrong(this.failure) : super(CharConstants.empty);

  final Failure failure;
}

/// The code was right; the parent goes in.
final class ParentGateOpened extends ParentGateState {
  const ParentGateOpened() : super(CharConstants.empty);
}
