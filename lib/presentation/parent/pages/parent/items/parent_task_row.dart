import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/clock_time_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/task_category_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/task_category_color.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One task in the parent's day list: its category's dot, what and when, and
/// whether it is done.
///
/// A finished task has no [onTap] — its points are paid, so there is nothing
/// to edit. [task] is the row.
class ParentTaskRow extends StatelessWidget {
  const ParentTaskRow({required this.task, required this.onTap, super.key});

  static const double _dot = 10;

  final TaskEntity task;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: _dot,
              height: _dot,
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? palette.success
                    : taskCategoryColor(palette, task.category),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(
                    taskCategoryCopy(l10n, task.category),
                    type: AppTextTypeEnum.body,
                    weight: FontWeight.w800,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    l10n.parentTaskMeta(
                      task.title,
                      clockTimeCopy(
                        task.scheduledAt.hour,
                        task.scheduledAt.minute,
                      ),
                      task.points,
                    ),
                    type: AppTextTypeEnum.caption,
                    color: palette.onSurfaceMuted,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppText(
              task.isCompleted ? l10n.parentTaskDone : l10n.parentTaskWaiting,
              type: AppTextTypeEnum.caption,
              weight: FontWeight.w800,
              color: task.isCompleted
                  ? palette.successInk
                  : palette.onSurfaceMuted,
            ),
          ],
        ),
      ),
    );
  }
}
