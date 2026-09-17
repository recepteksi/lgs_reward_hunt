import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_opacity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_dashed_border_painter.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row_circle.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row_points.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row_state_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One task on a day's list, in the three states a task can be in.
///
/// The row leads with the circle rather than with the subject, because the
/// circle is the thing being tapped and the thing whose state the whole row is
/// about: empty, ticked, or locked shut. Everything else on the row is there to
/// answer "which one is this" once the eye has found the circle.
///
/// [AppTaskRow.pending] is neutral and outlined. [AppTaskRow.done] fills with
/// the primary container and ticks the circle — the finished row gets brighter
/// rather than dimmer, and its title is never struck through: a line through
/// finished work reads as cancelled, which is the opposite of what happened.
/// [AppTaskRow.locked] is a dashed outline at reduced opacity, and its points
/// lose the plus sign, because they have not been earned and showing them as a
/// gain would be a promise the day has not made.
///
/// [title] is the topic, [meta] the line under it — subject, time, length —
/// already assembled by the caller, and [points] the figure in the pill.
class AppTaskRow extends StatelessWidget {
  const AppTaskRow.pending({
    required this.title,
    required this.meta,
    required this.points,
    this.onTap,
    super.key,
  }) : _state = AppTaskRowStateEnum.pending;

  const AppTaskRow.done({
    required this.title,
    required this.meta,
    required this.points,
    this.onTap,
    super.key,
  }) : _state = AppTaskRowStateEnum.done;

  const AppTaskRow.locked({
    required this.title,
    required this.meta,
    required this.points,
    this.onTap,
    super.key,
  }) : _state = AppTaskRowStateEnum.locked;

  final String title;

  final String meta;

  final int points;

  final VoidCallback? onTap;

  final AppTaskRowStateEnum _state;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);
    final bool isDone = _state == AppTaskRowStateEnum.done;
    final bool isLocked = _state == AppTaskRowStateEnum.locked;

    final Color titleColor = switch (_state) {
      AppTaskRowStateEnum.pending => palette.onSurface,
      AppTaskRowStateEnum.done => palette.onPrimaryContainer,
      AppTaskRowStateEnum.locked => palette.onSurfaceVariant,
    };
    final Color metaColor = isDone
        ? palette.onPrimaryContainer.withValues(alpha: AppOpacity.secondary)
        : palette.onSurfaceMuted;

    final Widget row = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: switch (_state) {
          AppTaskRowStateEnum.pending => palette.surfaceHigh,
          AppTaskRowStateEnum.done => palette.primaryContainer,
          AppTaskRowStateEnum.locked => Colors.transparent,
        },
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: isLocked
            ? null
            : Border.all(
                color: isDone ? palette.primary : palette.outline,
                width: AppSizes.borderStrong,
              ),
      ),
      child: Row(
        children: <Widget>[
          AppTaskRowCircle(state: _state),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppText(
                  title,
                  type: AppTextTypeEnum.body,
                  color: titleColor,
                  maxLines: ValueConstants.one,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  meta,
                  type: AppTextTypeEnum.caption,
                  color: metaColor,
                  maxLines: ValueConstants.one,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          AppTaskRowPoints(
            label: isLocked
                ? l10n.taskPointsLocked(points)
                : l10n.taskPointsAward(points),
            state: _state,
          ),
        ],
      ),
    );

    final Widget shaped = isLocked
        ? CustomPaint(
            painter: AppDashedBorderPainter(
              color: palette.outlineStrong,
              radius: AppRadii.lg,
              strokeWidth: AppSizes.borderStrong,
            ),
            child: Opacity(opacity: AppOpacity.dimmed, child: row),
          )
        : row;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: shaped,
    );
  }
}
