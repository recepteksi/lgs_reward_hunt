import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/clock_time_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/task_category_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/task_category_color.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_icon_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row_points.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row_state_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_template_editor.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/task/pages/task_setup/widgets/task_setup_repeat_pill.dart';

/// One line of the plan: a summary row that opens into its editor.
///
/// Closed, it reads like the task the child will see — category, topic, time,
/// length — with how often it comes back and what it is worth on the right,
/// and a cross to delete it. Tapping the text opens the editor under it; the
/// open line is outlined in the primary colour so it is clear which one the
/// chips below belong to.
///
/// [template] is the line, [isOpen] whether its editor shows, [onToggle] opens
/// or closes it, [onChanged] hands back the edited line, [onRemove] deletes it.
class TaskSetupTemplateRow extends StatelessWidget {
  const TaskSetupTemplateRow({
    required this.template,
    required this.isOpen,
    required this.onToggle,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  static const double _dot = 10;

  final TaskTemplateEntity template;

  final bool isOpen;

  final VoidCallback onToggle;

  final ValueChanged<TaskTemplateEntity> onChanged;

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);

    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(
          color: isOpen ? palette.primary : palette.outline,
          width: AppSizes.borderStrong,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppSpacing.lg,
              top: AppSpacing.xs,
              bottom: AppSpacing.xs,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: _dot,
                  height: _dot,
                  decoration: BoxDecoration(
                    color: taskCategoryColor(palette, template.category),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: GestureDetector(
                    onTap: onToggle,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AppText(
                            taskCategoryCopy(l10n, template.category),
                            type: AppTextTypeEnum.body,
                            weight: FontWeight.w800,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          AppText(
                            l10n.taskMeta(
                              template.topic,
                              clockTimeCopy(
                                template.startHour,
                                template.startMinuteOfHour,
                              ),
                              template.durationMinutes,
                            ),
                            type: AppTextTypeEnum.caption,
                            color: palette.onSurfaceMuted,
                            maxLines: ValueConstants.two,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                TaskSetupRepeatPill(template: template),
                const SizedBox(width: AppSpacing.xs),
                AppTaskRowPoints(
                  label: l10n.taskPointsLocked(template.points),
                  state: AppTaskRowStateEnum.pending,
                ),
                AppIconButton.plain(
                  icon: AppIcons.close,
                  semanticLabel: l10n.taskSetupRemove,
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
          if (isOpen)
            AppTaskTemplateEditor(
              template: template,
              onChanged: onChanged,
              onDone: onToggle,
            ),
        ],
      ),
    );
  }
}
