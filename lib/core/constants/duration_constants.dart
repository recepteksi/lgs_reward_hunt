/// Durations the app reasons about, named once.
///
/// A bare `Duration(seconds: 1)` in a widget is a number nobody can search for
/// and two of them drift apart the first time one is tuned.
abstract final class DurationConstants {
  /// How often the countdown recomputes. A countdown shown to the day only
  /// needs to notice midnight, but a ticking second is what makes it read as
  /// live rather than as a static number.
  static const Duration countdownTick = Duration(seconds: 1);

  /// The pause before a retry after a failed load.
  static const Duration retryBackoff = Duration(seconds: 3);
}
