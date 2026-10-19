import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The line under a finished day's tasks: the road moved, and the points are
/// spendable.
///
/// In the reward colour because it is about points — what was earned today is
/// in the pool the child can spend from. [points] is what the day earned.
class HomeDayCompleteBanner extends StatelessWidget {
  const HomeDayCompleteBanner({required this.points, super.key});

  final int points;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.rewardContainer,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: palette.reward, width: AppSizes.borderStrong),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: AppSizes.iconTile,
            height: AppSizes.iconTile,
            decoration: BoxDecoration(
              color: palette.reward,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppIcon(
                AppIcons.star,
                color: palette.onReward,
                size: AppSizes.iconSizeLarge,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  l10n.mapDayCompleteTitle,
                  type: AppTextTypeEnum.body,
                  weight: FontWeight.w900,
                  color: palette.rewardInk,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  l10n.mapDayCompleteBody(points),
                  type: AppTextTypeEnum.meta,
                  color: palette.rewardInk,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
