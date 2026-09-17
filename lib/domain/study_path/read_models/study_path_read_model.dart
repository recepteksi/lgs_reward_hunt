import 'package:lgs_reward_hunt/core/base/base_read_model.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/study_path/enums/study_stop_status_enum.dart';
import 'package:lgs_reward_hunt/domain/study_path/read_models/study_stop_read_model.dart';
import 'package:lgs_reward_hunt/domain/study_path/rules/study_map_rules.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';

/// The road from two days ago towards the exam, one stop a day.
///
/// `build` lays it out: `StudyMapRules.stopsBeforeToday` days before [today],
/// then one stop a day up to `StudyMapRules.visibleStops` — or to the exam, if
/// it comes sooner — each holding the tasks scheduled on it. The tasks are
/// the child's real ones, read for the whole window; nothing here is invented.
///
/// [todayIndex] is where today sits, and [reachedCount] is how many stops the
/// filled trail runs through — up to today, and one further once today is
/// done, so finishing a day visibly moves the child along. [zoneOf] is the
/// stretch a stop belongs to, counting from one. [daysBeyond] is how far the
/// exam lies past the last drawn stop — the dashed remainder of the road.
final class StudyPathReadModel extends BaseReadModel {
  const StudyPathReadModel._({
    required this.stops,
    required this.examDate,
    required this.today,
  });

  factory StudyPathReadModel.build({
    required List<TaskEntity> tasks,
    required DateTime today,
    required DateTime examDate,
  }) {
    final DateTime start = DateTime(
      today.year,
      today.month,
      today.day - StudyMapRules.stopsBeforeToday,
    );
    final DateTime examDay = DateTime(
      examDate.year,
      examDate.month,
      examDate.day,
    );
    final List<StudyStopReadModel> stops = <StudyStopReadModel>[];
    for (int index = 0; index < StudyMapRules.visibleStops; index++) {
      final DateTime day = DateTime(start.year, start.month, start.day + index);
      if (day.isAfter(examDay)) break;
      stops.add(
        StudyStopReadModel(
          day: day,
          today: today,
          tasks: tasks
              .where((TaskEntity task) => _sameDay(task.scheduledAt, day))
              .toList(),
        ),
      );
    }
    return StudyPathReadModel._(stops: stops, examDate: examDate, today: today);
  }

  final List<StudyStopReadModel> stops;

  final DateTime examDate;

  final DateTime today;

  DateTime get firstDay => stops.first.day;

  DateTime get lastDay => stops.last.day;

  int get todayIndex => stops.indexWhere(
    (StudyStopReadModel stop) => stop.status == StudyStopStatusEnum.today,
  );

  StudyStopReadModel get todayStop => stops[todayIndex];

  int get reachedCount =>
      todayIndex +
      (todayStop.isComplete ? ValueConstants.two : ValueConstants.one);

  int zoneOf(int index) =>
      index ~/ StudyMapRules.stopsPerZone + ValueConstants.one;

  int get daysBeyond {
    final DateTime examDay = DateTime(
      examDate.year,
      examDate.month,
      examDate.day,
    );
    final int days = examDay.difference(lastDay).inDays;
    return days < ValueConstants.zero ? ValueConstants.zero : days;
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  List<Object?> get props => <Object?>[stops, examDate, today];
}
