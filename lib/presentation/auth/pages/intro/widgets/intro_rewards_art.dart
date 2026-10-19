import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/intro/widgets/intro_reward_line.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/badge/app_status_badge.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The third slide's picture: a balance, and a reward waiting on a parent.
///
/// Two cards, top to bottom in the order the economy runs: the points banked,
/// then one spent on a request that has not been decided. The balance card is
/// the reward colour because it IS the points; the request card is a plain
/// surface with the pending badge, because until a parent answers nothing has
/// been spent. The note under the badge is the sentence the slide exists for —
/// every reward passes through the parent.
///
/// [_balance] and [_cost] are the design's sample figures.
class IntroRewardsArt extends StatelessWidget {
  const IntroRewardsArt({super.key});

  static const int _balance = 480;

  static const int _cost = 350;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppCard(
          color: palette.rewardContainer,
          radius: AppRadii.xl,
          border: BorderSide.none,
          child: IntroRewardLine(
            tileColor: palette.rewardSoft,
            icon: AppIcons.star,
            iconColor: palette.onReward,
            title: l10n.introBalanceTitle,
            titleColor: palette.onReward,
            meta: l10n.introBalanceMeta(_balance),
            metaColor: palette.rewardInk,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          radius: AppRadii.xl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IntroRewardLine(
                tileColor: palette.primaryContainer,
                icon: AppIcons.categoryOther,
                iconColor: palette.onPrimaryContainer,
                title: l10n.introRewardName,
                titleColor: palette.onSurface,
                meta: l10n.introRewardCost(_cost),
                metaColor: palette.rewardInk,
              ),
              const SizedBox(height: AppSpacing.md),
              Divider(
                height: AppSizes.borderStrong,
                thickness: AppSizes.borderStrong,
                color: palette.outline,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  AppStatusBadge.pending(label: l10n.introRewardPending),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppText(
                      l10n.introRewardNote,
                      type: AppTextTypeEnum.meta,
                      color: palette.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
