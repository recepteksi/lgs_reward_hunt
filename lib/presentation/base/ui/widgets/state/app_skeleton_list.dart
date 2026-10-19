import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_shimmer.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton.dart';

/// The loading shape of a setup list: a heading, two lines of body, and
/// [rows] cards each holding a face or icon and two lines.
///
/// Child setup, task setup, reward setup and the device step all open on a
/// list of cards under a heading; they share one skeleton so they load alike.
class AppSkeletonList extends StatelessWidget {
  const AppSkeletonList({this.rows = _defaultRows, super.key});

  static const int _defaultRows = 3;

  static const double _headingWidth = 180;

  static const double _bodyWidth = 240;

  static const double _shortWidth = 90;

  final int rows;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        const AppShimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppSkeleton.line(
                width: _headingWidth,
                size: AppTypography.heading,
              ),
              SizedBox(height: AppSpacing.md),
              AppSkeleton.line(width: _bodyWidth),
              SizedBox(height: AppSpacing.sm),
              AppSkeleton.line(width: _shortWidth * ValueConstants.two),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        for (int i = ValueConstants.zero; i < rows; i++) ...<Widget>[
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
                        AppSkeleton.line(),
                        SizedBox(height: AppSpacing.sm),
                        AppSkeleton.line(
                          width: _shortWidth,
                          size: AppTypography.caption,
                        ),
                      ],
                    ),
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
