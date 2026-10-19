import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_progress_ring_painter.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// How much of today is done, as a ring around the count.
///
/// The ring turns from the primary to the reward colour the moment the day is
/// complete. That is the whole reward for finishing: nothing pops up, nothing
/// has to be dismissed, the thing the student has been watching all day simply
/// changes colour — which is a stronger signal than a dialog and costs no taps.
///
/// [completed] and [total] are given rather than a fraction, because the ring
/// shows the pair as text in its middle and computing "3/4" from 0.75 is how a
/// widget ends up displaying "3/4" on a day with eight tasks.
class AppProgressRing extends StatelessWidget {
  const AppProgressRing({
    required this.completed,
    required this.total,
    this.size = AppSizes.progressRing,
    super.key,
  });

  final int completed;

  final int total;

  final double size;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final double progress = total <= ValueConstants.zero
        ? ValueConstants.zeroDouble
        : (completed / total)
              .clamp(ValueConstants.zeroDouble, ValueConstants.oneDouble)
              .toDouble();
    final bool isComplete = progress >= ValueConstants.oneDouble;

    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: AppProgressRingPainter(
          progress: progress,
          trackColor: palette.surfaceHigh,
          color: isComplete ? palette.reward : palette.primary,
          strokeWidth: AppSizes.progressRingStroke,
        ),
        child: Center(
          child: AppText(
            AppL10n.of(context).progressRatio(completed, total),
            type: AppTextTypeEnum.meta,
            weight: FontWeight.w900,
            color: palette.onSurface,
          ),
        ),
      ),
    );
  }
}
