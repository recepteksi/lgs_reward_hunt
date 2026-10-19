import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/parent/read_models/parent_dashboard_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/avatar/app_avatar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The device's child at a glance: how today is going, the streak, and the
/// balance. [dashboard] supplies all of it.
class ParentChildTodayCard extends StatelessWidget {
  const ParentChildTodayCard({required this.dashboard, super.key});

  static const double _face = 46;

  final ParentDashboardReadModel dashboard;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);

    return AppCard(
      radius: AppRadii.xxl,
      child: Row(
        children: <Widget>[
          AppAvatar(
            avatar: dashboard.household.avatarOf(dashboard.activeChild),
            size: _face,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  l10n.parentChildToday(dashboard.activeChild.name),
                  type: AppTextTypeEnum.title,
                  weight: FontWeight.w900,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  l10n.parentChildTodayLine(
                    dashboard.todayDone,
                    dashboard.todayTotal,
                    dashboard.streakDays,
                  ),
                  type: AppTextTypeEnum.meta,
                  color: palette.onSurfaceMuted,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              AppText(
                '${dashboard.balance}',
                type: AppTextTypeEnum.balance,
                color: palette.rewardInk,
                weight: FontWeight.w900,
              ),
              AppText(
                l10n.pointsUnit,
                type: AppTextTypeEnum.caption,
                color: palette.onSurfaceMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
