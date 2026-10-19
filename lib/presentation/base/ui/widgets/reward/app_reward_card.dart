import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_opacity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_progress_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/reward/app_reward_card_state_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/reward/app_reward_category_tile.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/reward/app_reward_status_dot.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One reward in the shop, in the four states a reward can be in.
///
/// A card that cannot be afforded is dimmed and kept in the grid rather than
/// hidden, and it shows how far away it is: a shop that only lists what you can
/// buy today has no goal in it, and the goal is the entire mechanism this
/// product runs on.
///
/// [AppRewardCard.available] is plain and complete. [AppRewardCard.locked]
/// fades and shows a part-filled bar. [AppRewardCard.pending] is outlined in
/// the reward colour with a clock at its shoulder — the request is with a
/// parent, and nothing on the card is actionable while it is.
/// [AppRewardCard.approved] turns the whole card green, the one place in the
/// app where the success colour is a fill rather than ink: it is a receipt, not
/// a status in a list.
///
/// [title] is the reward, [cost] its price, [icon] its category's glyph, and
/// [footer] the line that says where it stands — how many points are still
/// missing, or whose approval it is waiting on — already localized, because a
/// card does not compose sentences. [progress] only means anything on the locked card; elsewhere the
/// bar is full by definition.
class AppRewardCard extends StatelessWidget {
  const AppRewardCard.available({
    required this.title,
    required this.cost,
    required this.icon,
    required this.footer,
    this.onTap,
    super.key,
  }) : _state = AppRewardCardStateEnum.available,
       progress = ValueConstants.oneDouble;

  const AppRewardCard.locked({
    required this.title,
    required this.cost,
    required this.icon,
    required this.footer,
    required this.progress,
    this.onTap,
    super.key,
  }) : _state = AppRewardCardStateEnum.locked;

  const AppRewardCard.pending({
    required this.title,
    required this.cost,
    required this.icon,
    required this.footer,
    this.onTap,
    super.key,
  }) : _state = AppRewardCardStateEnum.pending,
       progress = ValueConstants.oneDouble;

  const AppRewardCard.approved({
    required this.title,
    required this.cost,
    required this.icon,
    required this.footer,
    this.onTap,
    super.key,
  }) : _state = AppRewardCardStateEnum.approved,
       progress = ValueConstants.oneDouble;

  final String title;

  final int cost;

  final String icon;

  final String footer;

  final double progress;

  final VoidCallback? onTap;

  final AppRewardCardStateEnum _state;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);
    final bool isApproved = _state == AppRewardCardStateEnum.approved;

    final Color titleColor = switch (_state) {
      AppRewardCardStateEnum.available ||
      AppRewardCardStateEnum.pending => palette.onSurface,
      AppRewardCardStateEnum.locked => palette.onSurfaceVariant,
      AppRewardCardStateEnum.approved => palette.successInk,
    };
    final Color costColor = switch (_state) {
      AppRewardCardStateEnum.available ||
      AppRewardCardStateEnum.pending => palette.rewardInk,
      AppRewardCardStateEnum.locked => palette.onSurfaceMuted,
      AppRewardCardStateEnum.approved => palette.successInk,
    };
    final Color footerColor = switch (_state) {
      AppRewardCardStateEnum.available => palette.successInk,
      AppRewardCardStateEnum.pending => palette.rewardInk,
      AppRewardCardStateEnum.locked => palette.onSurfaceMuted,
      AppRewardCardStateEnum.approved => palette.successInk,
    };

    final Widget card = Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isApproved ? palette.successContainer : palette.surface,
        borderRadius: BorderRadius.circular(AppRadii.xxl),
        border: Border.all(
          color: switch (_state) {
            AppRewardCardStateEnum.available ||
            AppRewardCardStateEnum.locked => palette.outline,
            AppRewardCardStateEnum.pending => palette.reward,
            AppRewardCardStateEnum.approved => palette.success,
          },
          width: AppSizes.borderStrong,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppRewardCategoryTile(icon: icon, state: _state),
              const Spacer(),
              if (_state == AppRewardCardStateEnum.pending)
                AppRewardStatusDot(
                  icon: AppIcons.clock,
                  background: palette.reward,
                  foreground: palette.onReward,
                ),
              if (isApproved)
                AppRewardStatusDot(
                  icon: AppIcons.check,
                  background: palette.success,
                  foreground: palette.successContainer,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            title,
            type: AppTextTypeEnum.badge,
            color: titleColor,
            maxLines: ValueConstants.two,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              AppText(
                NumberFormat.decimalPattern(
                  Localizations.localeOf(context).toLanguageTag(),
                ).format(cost),
                type: AppTextTypeEnum.cost,
                color: costColor,
              ),
              const SizedBox(width: AppSpacing.xs),
              AppText(
                l10n.pointsUnit,
                type: AppTextTypeEnum.label,
                color: isApproved
                    ? palette.successInk.withValues(alpha: AppOpacity.secondary)
                    : palette.onSurfaceMuted,
                style: const TextStyle(
                  letterSpacing: ValueConstants.zeroDouble,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppProgressBar(
            progress: progress,
            color: switch (_state) {
              AppRewardCardStateEnum.available ||
              AppRewardCardStateEnum.pending => palette.reward,
              AppRewardCardStateEnum.locked => palette.outlineStrong,
              AppRewardCardStateEnum.approved => palette.success,
            },
            trackColor: isApproved ? palette.surface : palette.surfaceHigh,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            footer,
            type: AppTextTypeEnum.label,
            color: footerColor,
            maxLines: ValueConstants.one,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(letterSpacing: ValueConstants.zeroDouble),
          ),
        ],
      ),
    );

    final Widget faded = _state == AppRewardCardStateEnum.locked
        ? Opacity(opacity: AppOpacity.locked, child: card)
        : card;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: faded,
    );
  }
}
