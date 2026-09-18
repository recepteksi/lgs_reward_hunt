/// The numbers progress is measured in.
///
/// [pointsPerLevel] is how many points earned — ever, not held — make a level;
/// a level is a record of work, so spending points on a reward never takes one
/// away. [historyDays] is how far back the progress page reads tasks: a school
/// year, which is as long as the exam this app is for.
///
/// The achievements are measured here too: [streakAchievementDays] is the
/// streak that earns the week badge, and [practiceMasterCount] the practice
/// exams that earn the last one.
abstract final class ProgressRules {
  static const int pointsPerLevel = 500;

  static const int historyDays = 365;

  static const int streakAchievementDays = 7;

  static const int practiceMasterCount = 10;
}
