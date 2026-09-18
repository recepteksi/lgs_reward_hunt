import 'package:lgs_reward_hunt/domain/task/enums/task_series_end_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns a [TaskSeriesEndEnum] into its words — the one place that mapping
/// happens.
String taskSeriesEndCopy(AppL10n l10n, TaskSeriesEndEnum end) => switch (end) {
  TaskSeriesEndEnum.oneWeek => l10n.taskSeriesOneWeek,
  TaskSeriesEndEnum.twoWeeks => l10n.taskSeriesTwoWeeks,
  TaskSeriesEndEnum.fourWeeks => l10n.taskSeriesFourWeeks,
  TaskSeriesEndEnum.untilExam => l10n.taskSeriesUntilExam,
};
