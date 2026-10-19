/// How a day reads on the progress calendar.
///
/// [complete] had tasks and every one was done. [today] is today, whatever its
/// state. [open] is everything else — a day to come, a day with nothing
/// planned, or a day that went differently — drawn the same, because the
/// calendar celebrates finished days rather than marking the others.
enum ProgressDayStatusEnum { complete, today, open }
