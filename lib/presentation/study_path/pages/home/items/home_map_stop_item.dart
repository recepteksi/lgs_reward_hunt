import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/domain/study_path/enums/study_stop_status_enum.dart';
import 'package:lgs_reward_hunt/domain/study_path/read_models/study_stop_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/map/app_map_stop.dart';

/// One day on the road, as the kit's map stop in the state that day is in.
///
/// Today is the big reward-coloured stop. A day with a practice exam is a
/// star, whenever it falls. A day gone by and finished is ticked; one that
/// went differently keeps its number and shows how far it got — not a cross,
/// because a missed day is not a failure the map should shout about. A day to
/// come is locked with its number, and the one the sheet is open on is ringed.
///
/// The label under the stop is what the day holds or earned. [stop] is the
/// day, [isSelected] whether the sheet shows it, [onTap] selects it.
class HomeMapStopItem extends StatelessWidget {
  const HomeMapStopItem({
    required this.stop,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final StudyStopReadModel stop;

  final bool isSelected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final int day = stop.day.day;

    final String label = switch (stop.status) {
      StudyStopStatusEnum.today =>
        stop.isComplete
            ? l10n.mapStopTodayDone(stop.earnedPoints)
            : l10n.mapStopToday(stop.completedCount, stop.tasks.length),
      StudyStopStatusEnum.passed =>
        !stop.hasTasks
            ? CharConstants.empty
            : stop.isComplete
            ? l10n.mapStopEarned(stop.earnedPoints)
            : l10n.mapStopProgress(stop.completedCount, stop.tasks.length),
      StudyStopStatusEnum.upcoming =>
        !stop.hasTasks
            ? CharConstants.empty
            : stop.isSpecial
            ? l10n.mapStopSpecial(stop.totalPoints)
            : l10n.mapStopTasks(stop.tasks.length, stop.totalPoints),
    };

    if (stop.status == StudyStopStatusEnum.today) {
      return AppMapStop.today(day: day, label: label, onTap: onTap);
    }
    if (stop.isSpecial) {
      return AppMapStop.special(label: label, onTap: onTap);
    }
    if (stop.status == StudyStopStatusEnum.passed && stop.isComplete) {
      return AppMapStop.done(label: label, onTap: onTap);
    }
    return isSelected
        ? AppMapStop.selected(day: day, label: label, onTap: onTap)
        : AppMapStop.locked(day: day, label: label, onTap: onTap);
  }
}
