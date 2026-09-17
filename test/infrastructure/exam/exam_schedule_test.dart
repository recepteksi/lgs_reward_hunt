import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/infrastructure/exam/repositories/exam_schedule_repository.dart';

/// The exam a student is counting towards is the next one, not this year's.
///
/// Asked in September for "this year's" exam, the schedule used to answer the
/// June that had already gone, and the countdown read zero for nine months.
void main() {
  const ExamScheduleRepository schedule = ExamScheduleRepository();

  test(
    'after this year\'s exam has passed, the countdown targets next year',
    () async {
      final exam = await schedule.nextExamAfter(DateTime(2026, 9, 17));

      expect(exam.right, DateTime(2027, 6, 13, 9));
    },
  );

  test('before this year\'s exam, the countdown targets this year', () async {
    final exam = await schedule.nextExamAfter(DateTime(2026, 3, 1));

    expect(exam.right, DateTime(2026, 6, 14, 9));
  });

  test('on exam morning the exam is still the one ahead', () async {
    final exam = await schedule.nextExamAfter(DateTime(2027, 6, 13, 7));

    expect(exam.right, DateTime(2027, 6, 13, 9));
  });
}
