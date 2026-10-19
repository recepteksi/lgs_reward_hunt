/// Which of the four states a status badge is showing.
///
/// The four are one vocabulary: a screen that invents a fifth is the screen
/// where "waiting" and "pending" start meaning different things to the same
/// reader. A caller does not pass one of these — it picks a named constructor
/// on `AppStatusBadge`, which is what keeps the vocabulary closed.
enum AppStatusToneEnum { pending, approved, rejected, locked }
