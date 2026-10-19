import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_shimmer.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton.dart';

/// The parent's page before the dashboard has loaded: the child's day card,
/// the tab switch and the approvals list.
class ParentSkeleton extends StatelessWidget {
  const ParentSkeleton({super.key});

  static const double _titleWidth = 140;

  static const double _lineWidth = 200;

  static const double _metaWidth = 90;

  static const double _actionWidth = 64;

  static const int _rows = 3;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxxl,
      ),
      children: <Widget>[
        const AppCard(
          child: AppShimmer(
            child: Row(
              children: <Widget>[
                AppSkeleton.circle(size: AppSizes.progressRing),
                SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppSkeleton.line(
                      width: _titleWidth,
                      size: AppTypography.title,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    AppSkeleton.line(
                      width: _metaWidth,
                      size: AppTypography.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const AppShimmer(
          child: AppSkeleton(height: AppSizes.chip, radius: AppRadii.round),
        ),
        const SizedBox(height: AppSpacing.md),
        for (int i = ValueConstants.zero; i < _rows; i++) ...<Widget>[
          const AppCard(
            child: AppShimmer(
              child: Row(
                children: <Widget>[
                  AppSkeleton.circle(size: AppSizes.iconTile),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AppSkeleton.line(width: _lineWidth),
                        SizedBox(height: AppSpacing.sm),
                        AppSkeleton.line(
                          width: _metaWidth,
                          size: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  AppSkeleton(
                    width: _actionWidth,
                    height: AppSizes.pointsPill,
                    radius: AppRadii.round,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
