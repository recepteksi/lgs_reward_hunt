import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_progress_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The student's level, with how far the next one is.
///
/// The number is set in a tile of its own so that it reads as a rank rather
/// than as a statistic — the same reason the title beside it is a name
/// (a rank name, not a range). The bar underneath is deliberately the
/// primary colour and not the reward colour: a level is not currency, it cannot
/// be spent, and colouring it amber would suggest it can.
///
/// [level] is the figure, [title] its name, [caption] the line saying what is
/// left, and [progress] how far along the current level is.
class AppLevelCard extends StatelessWidget {
  const AppLevelCard({
    required this.level,
    required this.title,
    required this.caption,
    required this.progress,
    required this.levelLabel,
    super.key,
  });

  static const double _barHeight = 8;

  final int level;

  final String title;

  final String caption;

  final double progress;

  final String levelLabel;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return AppCard(
      radius: AppRadii.xl,
      child: Row(
        children: <Widget>[
          Container(
            width: AppSizes.levelTile,
            height: AppSizes.levelTile,
            decoration: BoxDecoration(
              color: palette.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadii.xl),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppText(
                  levelLabel,
                  type: AppTextTypeEnum.label,
                  color: palette.primary,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  '$level',
                  type: AppTextTypeEnum.heading,
                  color: palette.primary,
                  style: const TextStyle(height: ValueConstants.oneDouble),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppText(
                  title,
                  type: AppTextTypeEnum.body,
                  weight: FontWeight.w900,
                  color: palette.onSurface,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(caption, type: AppTextTypeEnum.caption),
                const SizedBox(height: AppSpacing.sm),
                AppProgressBar(
                  progress: progress,
                  color: palette.primary,
                  height: _barHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
