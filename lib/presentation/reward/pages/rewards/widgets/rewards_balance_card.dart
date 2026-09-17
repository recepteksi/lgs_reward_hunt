import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/domain/reward/read_models/reward_shop_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_opacity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The balance at the head of the shop, on the reward colour.
///
/// The figure is the subject of the tab, so it is set at display size — the
/// same number the pill in the bar shows small. Under it, how many rewards
/// are on offer and the cheapest of them: the nearest goal. [shop] supplies
/// all three.
class RewardsBalanceCard extends StatelessWidget {
  const RewardsBalanceCard({required this.shop, super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);
    final int? cheapest = shop.cheapestOffered;
    final Color ink = palette.onReward;
    final Color quiet = ink.withValues(alpha: AppOpacity.secondary);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: palette.reward,
        borderRadius: BorderRadius.circular(AppRadii.xxxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            l10n.rewardsPoolLabel,
            type: AppTextTypeEnum.label,
            color: quiet,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              AppText(
                NumberFormat.decimalPattern(
                  Localizations.localeOf(context).toLanguageTag(),
                ).format(shop.balance),
                type: AppTextTypeEnum.display,
                color: ink,
                weight: FontWeight.w900,
              ),
              const SizedBox(width: AppSpacing.sm),
              AppText(
                l10n.pointsUnit,
                type: AppTextTypeEnum.balance,
                color: quiet,
                weight: FontWeight.w900,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            cheapest == null
                ? l10n.rewardsSummaryEmpty
                : l10n.rewardsSummary(shop.offered.length, cheapest),
            type: AppTextTypeEnum.meta,
            color: quiet,
          ),
        ],
      ),
    );
  }

  final RewardShopReadModel shop;
}
