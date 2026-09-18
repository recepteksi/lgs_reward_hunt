import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_shimmer.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton.dart';

/// `AppChildPill` before the child is known: the same pill, a face-sized
/// circle and two short lines, shimmering.
///
/// Only shown on a first load with nothing remembered; once a child has been
/// read, tabs show the real pill straight away.
class AppChildPillSkeleton extends StatelessWidget {
  const AppChildPillSkeleton({super.key});

  static const double _face = 32;

  static const double _name = 48;

  static const double _subtitle = 36;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: palette.navigationBar,
        borderRadius: BorderRadius.circular(AppRadii.round),
        border: Border.all(color: palette.mapEdge, width: AppSizes.border),
      ),
      child: const AppShimmer(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppSkeleton.circle(size: _face),
            SizedBox(width: AppSpacing.sm),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppSkeleton.line(width: _name, size: AppTypography.caption),
                SizedBox(height: AppSpacing.xs),
                AppSkeleton.line(width: _subtitle, size: AppTypography.label),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
