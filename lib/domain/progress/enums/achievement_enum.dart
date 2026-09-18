/// The badges a child can earn, in the order the progress page lists them.
///
/// [weekStreak] is a streak of `ProgressRules.streakAchievementDays`.
/// [firstPracticeExam] is the first practice exam finished. [practiceMaster]
/// is `ProgressRules.practiceMasterCount` of them. Whether one is earned, and
/// how far along it is, is `ProgressReadModel`'s answer.
enum AchievementEnum { weekStreak, firstPracticeExam, practiceMaster }
