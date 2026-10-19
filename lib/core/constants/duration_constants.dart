/// Durations the app reasons about, named once.
///
/// A bare `Duration(seconds: 1)` in a widget is a number nobody can search for
/// and two of them drift apart the first time one is tuned.
///
/// [retryBackoff] is the pause before a retry after a failed load.
///
/// [pointsFlash] is how long the "+20P" rises off the balance after a task is
/// ticked — long enough to read, gone before the next tap.
///
/// [pageTurn] is one slide of the intro sliding in, and the indicator segment
/// filling beside it — the same quarter second, so the two land together.
///
/// [shimmer] is one sweep of the loading highlight across a skeleton — slow
/// enough to read as waiting, not as an alarm.
abstract final class DurationConstants {
  static const Duration retryBackoff = Duration(seconds: 3);
  static const Duration pageTurn = Duration(milliseconds: 250);
  static const Duration shimmer = Duration(milliseconds: 1400);
  static const Duration pointsFlash = Duration(milliseconds: 1200);
}
