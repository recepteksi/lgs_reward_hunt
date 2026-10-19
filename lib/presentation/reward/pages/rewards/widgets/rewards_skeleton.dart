import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_shimmer.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton.dart';

/// The shop before it has loaded: the balance card, a row of category chips,
/// and a two-column grid of reward cards.
class RewardsSkeleton extends StatelessWidget {
  const RewardsSkeleton({super.key});

  static const int _columns = 2;

  static const int _cards = 4;

  static const double _cardAspect = 0.78;

  static const List<double> _chips = <double>[56, 72, 64, 60];

  static const double _captionWidth = 110;

  static const double _balanceWidth = 90;

  static const double _imageHeight = 64;

  static const double _nameWidth = 100;

  static const double _costWidth = 56;

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppSkeleton.line(
                        width: _captionWidth,
                        size: AppTypography.caption,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppSkeleton.line(
                        width: _balanceWidth,
                        size: AppTypography.heading,
                      ),
                    ],
                  ),
                ),
                AppSkeleton.circle(size: AppSizes.iconTile),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppShimmer(
          child: Row(
            children: <Widget>[
              for (final double width in _chips) ...<Widget>[
                AppSkeleton(
                  width: width,
                  height: AppSizes.chip,
                  radius: AppRadii.round,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: _columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: _cardAspect,
          children: <Widget>[
            for (int i = ValueConstants.zero; i < _cards; i++)
              const AppCard(
                padding: EdgeInsets.all(AppSpacing.md),
                child: AppShimmer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppSkeleton(height: _imageHeight, radius: AppRadii.sm),
                      SizedBox(height: AppSpacing.md),
                      AppSkeleton.line(width: _nameWidth),
                      SizedBox(height: AppSpacing.sm),
                      AppSkeleton(
                        width: _costWidth,
                        height: AppSizes.pointsPill,
                        radius: AppRadii.round,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
