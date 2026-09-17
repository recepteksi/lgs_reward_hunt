import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_repeat_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_series_end_enum.dart';
import 'package:lgs_reward_hunt/domain/task/rules/draft_rules.dart';
import 'package:lgs_reward_hunt/domain/task/rules/task_plan_rules.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/task_series_end_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_chip.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_template_editor.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The parent's task sheet: a new task on a day, or an existing one.
///
/// The fields are the kit's task editor, the same one the setup plan uses. A
/// new task may repeat, and then says until when; an existing task is one
/// day's, so it has no rhythm to change and can be removed instead. The sheet
/// closes before handing its answer on — [onAdd], [onSave], [onDelete] — so
/// the page underneath shows the Cubit working rather than a sheet frozen over
/// it.
///
/// [day] is the day being planned and [task] the one being edited, or null for
/// a new one.
class ParentTaskSheet extends StatefulWidget {
  const ParentTaskSheet({
    required this.day,
    required this.task,
    required this.onAdd,
    required this.onSave,
    required this.onDelete,
    super.key,
  });

  static const String _newId = '${DraftRules.idPrefix}new';

  final DateTime day;

  final TaskEntity? task;

  final void Function(TaskTemplateEntity template, TaskSeriesEndEnum end) onAdd;

  final ValueChanged<TaskTemplateEntity> onSave;

  final VoidCallback onDelete;

  @override
  State<ParentTaskSheet> createState() => _ParentTaskSheetState();
}

/// Holds the task being edited and how long a new one repeats.
class _ParentTaskSheetState extends State<ParentTaskSheet> {
  late TaskTemplateEntity _template = _initial();

  TaskSeriesEndEnum _end = TaskSeriesEndEnum.oneWeek;

  TaskTemplateEntity _initial() {
    final TaskEntity? task = widget.task;
    if (task == null) {
      return TaskTemplateEntity.draft(ParentTaskSheet._newId)
          .withRepeat(TaskRepeatEnum.once);
    }
    return TaskTemplateEntity.create(
      id: task.id,
      kind: task.category.kind,
      category: task.category,
      topic: task.title,
      startMinute:
          task.scheduledAt.hour * TaskPlanRules.minutesPerHour +
          task.scheduledAt.minute,
      durationMinutes: task.durationMinutes,
      points: task.points,
      repeat: TaskRepeatEnum.once,
    ).fold(
      (_) => TaskTemplateEntity.draft(task.id),
      (TaskTemplateEntity template) => template,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final bool isNew = widget.task == null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: AppText(
                    isNew ? l10n.parentTaskSheetNew : l10n.parentTaskSheetEdit,
                    type: AppTextTypeEnum.title,
                    weight: FontWeight.w900,
                  ),
                ),
                AppText(
                  DateFormat.MMMMEEEEd(
                    Localizations.localeOf(context).toLanguageTag(),
                  ).format(widget.day),
                  type: AppTextTypeEnum.meta,
                  color: AppPalette.of(context).primary,
                ),
              ],
            ),
          ),
          AppTaskTemplateEditor(
            template: _template,
            showRepeat: isNew,
            onChanged: (TaskTemplateEntity value) =>
                setState(() => _template = value),
          ),
          if (isNew && _template.repeat != TaskRepeatEnum.once)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(l10n.parentTaskEndLabel, type: AppTextTypeEnum.label),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: <Widget>[
                      for (final TaskSeriesEndEnum end
                          in TaskSeriesEndEnum.values)
                        AppChip(
                          label: taskSeriesEndCopy(l10n, end),
                          isSelected: end == _end,
                          onTap: () => setState(() => _end = end),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AppButton.filled(
                  label: isNew ? l10n.parentTaskAdd : l10n.parentTaskSave,
                  isExpanded: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (isNew) {
                      widget.onAdd(_template, _end);
                    } else {
                      widget.onSave(_template);
                    }
                  },
                ),
                if (!isNew) ...<Widget>[
                  const SizedBox(height: AppSpacing.sm),
                  AppButton.errorOutlined(
                    label: l10n.taskSetupRemove,
                    isExpanded: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onDelete();
                    },
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                AppButton.text(
                  label: l10n.commonCancel,
                  isExpanded: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
