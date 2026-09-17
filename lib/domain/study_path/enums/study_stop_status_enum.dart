/// Where a day on the map stands relative to today.
///
/// [passed] is a day gone by, [today] is today, [upcoming] is a day that has
/// not opened. Whether a passed day was finished is a separate question —
/// `StudyStopReadModel.isComplete` — because a day that went differently is
/// still a day that passed.
enum StudyStopStatusEnum { passed, today, upcoming }
