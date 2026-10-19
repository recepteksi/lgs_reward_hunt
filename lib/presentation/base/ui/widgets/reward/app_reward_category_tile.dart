import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/reward/app_reward_card_state_enum.dart';

/// The rounded square holding the reward's category glyph.
class AppRewardCategoryTile extends StatelessWidget {
  const AppRewardCategoryTile({
    super.key,
    required this.icon,
    required this.state,
  });

  final String icon;

  final AppRewardCardStateEnum state;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Container(
      width: AppSizes.iconTile,
      height: AppSizes.iconTile,
      decoration: BoxDecoration(
        color: switch (state) {
          AppRewardCardStateEnum.available => palette.primaryContainer,
          AppRewardCardStateEnum.locked => palette.surfaceHigh,
          AppRewardCardStateEnum.pending => palette.rewardSoft,
          AppRewardCardStateEnum.approved => palette.surface,
        },
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Center(
        child: AppIcon(
          icon,
          size: AppSizes.iconSize,
          color: switch (state) {
            AppRewardCardStateEnum.available => palette.primary,
            AppRewardCardStateEnum.locked => palette.onSurfaceMuted,
            AppRewardCardStateEnum.pending => palette.rewardInk,
            AppRewardCardStateEnum.approved => palette.success,
          },
        ),
      ),
    );
  }
}
