import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row_points.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row_state_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One request waiting on the parent, with the two answers.
///
/// Outlined in the reward colour, because it is about points. The line under
/// it says what the balance will be — the points are already held, so a yes
/// changes nothing and a no gives them back. [request] is the request,
/// [childName] whose it is, [balanceAfter] the balance if approved, and
/// [onApprove] / [onReject] the answers, null while one is on its way.
class ParentApprovalCard extends StatelessWidget {
  const ParentApprovalCard({
    required this.request,
    required this.childName,
    required this.balanceAfter,
    required this.onApprove,
    required this.onReject,
    super.key,
  });

  final RedemptionEntity request;

  final String childName;

  final int balanceAfter;

  final VoidCallback? onApprove;

  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);
    final String date = DateFormat.MMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).add_Hm().format(request.requestedAt);

    return AppCard(
      radius: AppRadii.xxl,
      border: BorderSide(color: palette.reward, width: AppSizes.borderStrong),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: AppSizes.iconTile,
                height: AppSizes.iconTile,
                decoration: BoxDecoration(
                  color: palette.rewardContainer,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Center(
                  child: AppIcon(AppIcons.rewards, color: palette.rewardInk),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppText(
                      request.rewardName,
                      type: AppTextTypeEnum.title,
                      weight: FontWeight.w900,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppText(
                      l10n.parentApprovalMeta(childName, date),
                      type: AppTextTypeEnum.caption,
                      color: palette.onSurfaceMuted,
                    ),
                  ],
                ),
              ),
              AppTaskRowPoints(
                label: l10n.taskPointsLocked(request.costAtRequest),
                state: AppTaskRowStateEnum.pending,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppText(
            l10n.parentApprovalAfter(balanceAfter),
            type: AppTextTypeEnum.caption,
            color: palette.onSurfaceMuted,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: AppButton.outlined(
                  label: l10n.parentReject,
                  isExpanded: true,
                  onPressed: onReject,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton.filled(
                  label: l10n.parentApprove,
                  isExpanded: true,
                  onPressed: onApprove,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
