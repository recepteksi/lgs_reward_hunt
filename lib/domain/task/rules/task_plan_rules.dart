/// The numbers the setup task plan is built from.
///
/// Rules rather than measurements, so they live in `core/` beside the points
/// rules they sit inside: every duration here is within
/// `PointsRules.minTaskMinutes`…`maxTaskMinutes`, and [pointsStep] is the
/// stepper's move inside `PointsRules.minTaskPoints`…`maxTaskPoints`.
///
/// [horizonDays] is how far ahead saving a plan writes tasks: two weeks, so
/// the map has days to show and the parent side has a fortnight to adjust
/// before anything runs out. Times are minutes after midnight —
/// [startMinuteOptions] are the five a parent can pick (16:00, 17:30, 19:00,
/// 20:00, 21:00). [lessonMinuteOptions] and [choreMinuteOptions] are the
/// lengths offered for each kind, because a chore that takes forty minutes and
/// a lesson that takes five are both the wrong plan.
///
/// A new task starts from [newStartMinute], [newDurationMinutes] and
/// [newPoints] — a thirty-minute evening lesson worth twenty. [minutesPerHour]
/// and [minutesPerDay] turn a start minute into a clock time and bound it.
abstract final class TaskPlanRules {
  static const int horizonDays = 14;

  static const int minutesPerHour = 60;

  static const int minutesPerDay = 1440;

  static const List<int> startMinuteOptions = <int>[
    960,
    1050,
    1140,
    1200,
    1260,
  ];

  static const List<int> lessonMinuteOptions = <int>[20, 25, 30, 40];

  static const List<int> choreMinuteOptions = <int>[5, 10, 15, 30];

  static const int pointsStep = 5;

  static const int newStartMinute = 1140;

  static const int newDurationMinutes = 30;

  static const int newPoints = 20;
}
