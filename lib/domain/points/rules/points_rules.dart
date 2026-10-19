/// The numbers the points economy runs on.
///
/// Named here rather than at the places that enforce them, because a bound
/// spelled at two call sites is two bounds the first time one is tuned — and
/// the symptom of that is a child earning points a parent never agreed to.
///
/// [minTaskPoints] and [maxTaskPoints] bound what a single task may be worth.
/// A parent who can set a task to 10.000 points has made the reward shop
/// meaningless in one evening; one who can set it to 0 has made the task
/// pointless. [minTaskMinutes] and [maxTaskMinutes] bound the same way for
/// duration — a 12-hour "task" is not a task.
///
/// [minRewardCost] and [maxRewardCost] bound the shop. [dayCompletionBonus] is
/// what finishing every task scheduled for a day is worth on top of the tasks
/// themselves: the whole point of a daily plan is that it is finished, so the
/// last task of the day has to be worth more than the first.
///
/// [minTasksForDayBonus] is what stops that bonus from being free money. A day
/// holding one task is trivially "all done" the moment that task is, so
/// without a floor a parent who schedules a single 5-point task collects the
/// bonus every day for nothing — and the bonus is meant to reward finishing a
/// plan, which one task is not.
///
/// [linkCodeLength] is how many characters a parent reads out to a child.
abstract final class PointsRules {
  static const int minTaskPoints = 5;
  static const int maxTaskPoints = 200;

  static const int minTaskMinutes = 5;
  static const int maxTaskMinutes = 240;

  static const int minRewardCost = 10;
  static const int maxRewardCost = 100000;

  static const int dayCompletionBonus = 25;
  static const int minTasksForDayBonus = 2;

  static const int linkCodeLength = 6;
}
