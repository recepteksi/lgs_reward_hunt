import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/points/rules/points_rules.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_kind_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_repeat_enum.dart';
import 'package:lgs_reward_hunt/domain/task/rules/task_plan_rules.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/clock_time_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/task_category_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/task_kind_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/task_repeat_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_chip.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_option_tile.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_stepper.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_text_field.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// A task's fields as controls: the editor under an open line of the setup
/// plan, and the body of the parent's task sheet.
///
/// Kind, category, topic, time, length, points and rhythm, top to bottom in
/// the design's order. Every control hands back a new line built by the line's
/// own `with…` edit, so switching a lesson to a chore also moves its category
/// and length onto ones a chore allows — the page never has to know that rule.
///
/// The choices offered come from the rules, not from the widget:
/// `TaskCategoryEnum.of` for the kind's list, `TaskPlanRules` for the times,
/// the kind's `minuteOptions` for the lengths, `PointsRules` for the stepper.
///
/// The topic field keeps its own controller, so typing is not reset each time
/// the task comes back from the Cubit. [template] is the task, [onChanged] the
/// edit, and [onDone] — when given — a button at the foot that closes it;
/// [showRepeat] hides the rhythm for a task that is a single day's.
class AppTaskTemplateEditor extends StatefulWidget {
  const AppTaskTemplateEditor({
    required this.template,
    required this.onChanged,
    this.onDone,
    this.showRepeat = true,
    super.key,
  });

  final TaskTemplateEntity template;

  final ValueChanged<TaskTemplateEntity> onChanged;

  final VoidCallback? onDone;

  final bool showRepeat;

  @override
  State<AppTaskTemplateEditor> createState() => _AppTaskTemplateEditorState();
}

/// Holds the topic being typed.
class _AppTaskTemplateEditorState extends State<AppTaskTemplateEditor> {
  late final TextEditingController _topic = TextEditingController(
    text: widget.template.topic,
  );

  @override
  void dispose() {
    _topic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final TaskTemplateEntity template = widget.template;
    final ValueChanged<TaskTemplateEntity> onChanged = widget.onChanged;
    final bool isChore = template.kind == TaskKindEnum.chore;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppText(l10n.taskSetupKind, type: AppTextTypeEnum.label),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              for (final TaskKindEnum kind in TaskKindEnum.values) ...<Widget>[
                if (kind != TaskKindEnum.values.first)
                  const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppOptionTile(
                    label: taskKindCopy(l10n, kind),
                    isSelected: kind == template.kind,
                    onTap: () => onChanged(template.withKind(kind)),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppText(
            isChore
                ? l10n.taskSetupCategoryChore
                : l10n.taskSetupCategoryLesson,
            type: AppTextTypeEnum.label,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final TaskCategoryEnum category in TaskCategoryEnum.of(
                template.kind,
              ))
                AppChip(
                  label: taskCategoryCopy(l10n, category),
                  isSelected: category == template.category,
                  onTap: () => onChanged(template.withCategory(category)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: isChore
                ? l10n.taskSetupTopicChore
                : l10n.taskSetupTopicLesson,
            hint: isChore
                ? l10n.taskSetupTopicHintChore
                : l10n.taskSetupTopicHintLesson,
            controller: _topic,
            onChanged: (String value) => onChanged(template.withTopic(value)),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppText(l10n.taskSetupTime, type: AppTextTypeEnum.label),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final int minute in TaskPlanRules.startMinuteOptions)
                AppChip(
                  label: clockTimeCopy(
                    minute ~/ TaskPlanRules.minutesPerHour,
                    minute % TaskPlanRules.minutesPerHour,
                  ),
                  isSelected: minute == template.startMinute,
                  onTap: () => onChanged(template.withStartMinute(minute)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppText(l10n.taskSetupDuration, type: AppTextTypeEnum.label),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final int minutes in template.kind.minuteOptions)
                AppChip(
                  label: l10n.taskSetupMinutes(minutes),
                  isSelected: minutes == template.durationMinutes,
                  onTap: () => onChanged(template.withDuration(minutes)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: AppText(
                  l10n.taskSetupPoints,
                  type: AppTextTypeEnum.label,
                ),
              ),
              AppStepper(
                value: template.points,
                step: TaskPlanRules.pointsStep,
                minimum: PointsRules.minTaskPoints,
                maximum: PointsRules.maxTaskPoints,
                decreaseLabel: l10n.commonPointsDown,
                increaseLabel: l10n.commonPointsUp,
                onChanged: (int value) => onChanged(template.withPoints(value)),
              ),
            ],
          ),
          if (widget.showRepeat) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            AppText(l10n.taskSetupRepeat, type: AppTextTypeEnum.label),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                for (final TaskRepeatEnum repeat in TaskRepeatEnum.values)
                  AppChip(
                    label: taskRepeatCopy(l10n, repeat),
                    isSelected: repeat == template.repeat,
                    onTap: () => onChanged(template.withRepeat(repeat)),
                  ),
              ],
            ),
          ],
          if (widget.onDone != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            AppButton.tonal(
              label: l10n.commonDone,
              isExpanded: true,
              onPressed: widget.onDone,
            ),
          ],
        ],
      ),
    );
  }
}
