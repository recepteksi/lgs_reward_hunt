/// What the app requires of a password and a parent's PIN.
///
/// They are rules rather than measurements, so they live beside the points
/// rules in `core/` and not in the theme. Both are checked in the domain before
/// anything reaches a repository — a screen may also check them to keep a
/// button disabled, but it is never the only thing that does.
///
/// [pinLength] is four because the PIN guards a screen, not money: it stops a
/// child wandering into the parent's side, and a longer code would only mean a
/// parent writing it down. [passwordMinLength] is the real credential and is
/// held to the usual floor.
abstract final class AuthRules {
  static const int passwordMinLength = 8;

  static const int pinLength = 4;
}
