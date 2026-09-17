import 'package:lgs_reward_hunt/domain/task/enums/task_repeat_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns a [TaskRepeatEnum] into its words — the one place that mapping
/// happens, so a sixth rhythm does not compile until it has a name.
String taskRepeatCopy(AppL10n l10n, TaskRepeatEnum repeat) => switch (repeat) {
  TaskRepeatEnum.once => l10n.taskRepeatOnce,
  TaskRepeatEnum.daily => l10n.taskRepeatDaily,
  TaskRepeatEnum.weekdays => l10n.taskRepeatWeekdays,
  TaskRepeatEnum.weekend => l10n.taskRepeatWeekend,
  TaskRepeatEnum.weekly => l10n.taskRepeatWeekly,
};
