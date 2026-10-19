import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_shimmer.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton.dart';

/// Progress before it has loaded: the level card, two stat tiles and the
/// week's bars.
class ProgressSkeleton extends StatelessWidget {
  const ProgressSkeleton({super.key});

  static const List<double> _bars = <double>[46, 70, 34, 70, 70, 20, 12];

  static const double _chartHeight = 74;

  static const double _labelWidth = 70;

  static const double _titleWidth = 150;

  static const double _valueWidth = 64;

  static const double _headingWidth = 110;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        const AppCard(
          child: AppShimmer(
            child: Row(
              children: <Widget>[
                AppSkeleton.circle(size: AppSizes.levelTile),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppSkeleton.line(
                        width: _labelWidth,
                        size: AppTypography.caption,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppSkeleton.line(
                        width: _titleWidth,
                        size: AppTypography.title,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppSkeleton(
                        height: AppSizes.progressBar,
                        radius: AppRadii.round,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Row(
          children: <Widget>[
            Expanded(child: _tile),
            SizedBox(width: AppSpacing.md),
            Expanded(child: _tile),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: AppShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const AppSkeleton.line(width: _headingWidth),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: _chartHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      for (final double bar in _bars) ...<Widget>[
                        Expanded(
                          child: AppSkeleton(height: bar, radius: AppRadii.xs),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static const Widget _tile = AppCard(
    child: AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppSkeleton.line(width: _labelWidth, size: AppTypography.caption),
          SizedBox(height: AppSpacing.sm),
          AppSkeleton.line(width: _valueWidth, size: AppTypography.heading),
        ],
      ),
    ),
  );
}
