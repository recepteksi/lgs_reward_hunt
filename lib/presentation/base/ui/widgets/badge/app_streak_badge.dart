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

/// How many days in a row, when there is a row.
///
/// Below two days it draws nothing at all: one day is not a streak, and a badge
/// that says "1 day" on the first day teaches a student that the number is
/// decoration. Hiding it here rather than at the call site means every screen
/// hides it on the same day.
///
/// It carries the reward colour because a streak is earned, and the flame
/// rather than the star because it is the one earned thing that is not points.
///
/// [days] is the run itself; the words come from [AppL10n], where the plural
/// belongs.
class AppStreakBadge extends StatelessWidget {
  const AppStreakBadge({required this.days, super.key});

  static const int _minimumStreak = 2;

  final int days;

  @override
  Widget build(BuildContext context) {
    if (days < _minimumStreak) {
      return const SizedBox.shrink();
    }

    final AppPalette palette = AppPalette.of(context);

    return Container(
      height: AppSizes.streakPill,
      padding: const EdgeInsets.only(left: AppSpacing.sm, right: AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.rewardSoft,
        borderRadius: BorderRadius.circular(AppRadii.round),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppIcon(
            AppIcons.flame,
            color: palette.reward,
            size: AppSizes.iconSizeMedium,
          ),
          const SizedBox(width: AppSpacing.sm),
          AppText(
            AppL10n.of(context).streakDays(days),
            type: AppTextTypeEnum.body,
            color: palette.rewardInk,
            weight: FontWeight.w900,
          ),
        ],
      ),
    );
  }
}
