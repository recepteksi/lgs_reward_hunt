/// How often a planned task comes back.
///
/// [occursOn] is the rule, and the only place it lives: the setup summary
/// counts today's points with it and the backend writes a fortnight of tasks
/// with it, so the two cannot disagree about which days a task falls on.
///
/// Every answer is relative to `from`, the day the plan was saved: [once] is
/// that day only, [weekly] is that day's weekday, and the rest ignore it —
/// [daily] is every day, [weekdays] Monday to Friday, [weekend] Saturday and
/// Sunday. A day before `from` never has a task.
enum TaskRepeatEnum {
  once,
  daily,
  weekdays,
  weekend,
  weekly;

  bool occursOn(DateTime day, {required DateTime from}) {
    final DateTime date = DateTime(day.year, day.month, day.day);
    final DateTime start = DateTime(from.year, from.month, from.day);
    if (date.isBefore(start)) return false;

    return switch (this) {
      TaskRepeatEnum.once => date == start,
      TaskRepeatEnum.daily => true,
      TaskRepeatEnum.weekdays => date.weekday <= DateTime.friday,
      TaskRepeatEnum.weekend => date.weekday >= DateTime.saturday,
      TaskRepeatEnum.weekly => date.weekday == start.weekday,
    };
  }

  static TaskRepeatEnum? fromName(String? name) {
    for (final TaskRepeatEnum repeat in values) {
      if (repeat.name == name) return repeat;
    }
    return null;
  }
}
