/// Which of the five states a stop on the path is in.
///
/// [today] is the only one in the reward colour and the largest object in the
/// app; [special] marks a heavier day — a practice exam, a weekly review;
/// [selected] is a future day being inspected rather than opened, which is why
/// it is a ring rather than a fill.
enum AppMapStopKindEnum { done, today, special, locked, selected }
