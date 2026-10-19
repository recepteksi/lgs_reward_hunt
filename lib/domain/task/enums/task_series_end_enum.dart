import 'package:lgs_reward_hunt/core/constants/value_constants.dart';

/// How long a repeating task a parent adds keeps coming back.
///
/// [oneWeek], [twoWeeks] and [fourWeeks] are that many weeks from its first
/// day; [untilExam] runs to the day before the exam. [lastDay] is the answer,
/// given the first day and the exam — the one place the end of a series is
/// worked out.
enum TaskSeriesEndEnum {
  oneWeek,
  twoWeeks,
  fourWeeks,
  untilExam;

  DateTime lastDay({required DateTime from, required DateTime examDate}) {
    final int? weeks = switch (this) {
      TaskSeriesEndEnum.oneWeek => ValueConstants.one,
      TaskSeriesEndEnum.twoWeeks => ValueConstants.two,
      TaskSeriesEndEnum.fourWeeks => ValueConstants.two * ValueConstants.two,
      TaskSeriesEndEnum.untilExam => null,
    };
    if (weeks == null) {
      return DateTime(examDate.year, examDate.month, examDate.day - 1);
    }
    return DateTime(
      from.year,
      from.month,
      from.day + weeks * DateTime.daysPerWeek - 1,
    );
  }
}
