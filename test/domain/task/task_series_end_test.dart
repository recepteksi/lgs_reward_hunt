import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_series_end_enum.dart';

/// Where a repeating task a parent adds stops.
void main() {
  final DateTime wednesday = DateTime(2026, 9, 16);
  final DateTime exam = DateTime(2027, 6, 13, 9);

  test(
    'a number of weeks ends the day before the same weekday comes round',
    () {
      expect(
        TaskSeriesEndEnum.oneWeek.lastDay(from: wednesday, examDate: exam),
        DateTime(2026, 9, 22),
      );
      expect(
        TaskSeriesEndEnum.fourWeeks.lastDay(from: wednesday, examDate: exam),
        DateTime(2026, 10, 13),
      );
    },
  );

  test('until the exam ends the day before it', () {
    expect(
      TaskSeriesEndEnum.untilExam.lastDay(from: wednesday, examDate: exam),
      DateTime(2027, 6, 12),
    );
  });
}
