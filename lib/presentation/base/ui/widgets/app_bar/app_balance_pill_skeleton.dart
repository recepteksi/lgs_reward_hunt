import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_shimmer.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton.dart';

/// `AppBalancePill` before the balance is known — the prominent points
/// badge's footprint, shimmering.
class AppBalancePillSkeleton extends StatelessWidget {
  const AppBalancePillSkeleton({super.key});

  static const double _width = 76;

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: AppSkeleton(
        width: _width,
        height: AppSizes.pointsPillLarge,
        radius: AppRadii.round,
      ),
    );
  }
}
