import 'package:lgs_reward_hunt/domain/task/enums/task_kind_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns a [TaskKindEnum] into its word — the one place that mapping happens.
String taskKindCopy(AppL10n l10n, TaskKindEnum kind) => switch (kind) {
  TaskKindEnum.lesson => l10n.taskKindLesson,
  TaskKindEnum.chore => l10n.taskKindChore,
};
