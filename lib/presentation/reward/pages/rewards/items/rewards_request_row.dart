import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/redemption_status_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/redemption_status_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/badge/app_status_badge.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One request in the child's history: the reward, when and for how much, and
/// where it stands.
///
/// A refusal carries the parent's note under it when there is one — a no with
/// a reason is a no a child can accept. [request] is the row.
class RewardsRequestRow extends StatelessWidget {
  const RewardsRequestRow({required this.request, super.key});

  final RedemptionEntity request;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);
    final String label = redemptionStatusCopy(l10n, request.status);
    final String? note = request.parentNote;
    final String date = DateFormat.MMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).add_Hm().format(request.requestedAt);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  request.rewardName,
                  type: AppTextTypeEnum.body,
                  weight: FontWeight.w800,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  l10n.rewardsRequestMeta(date, request.costAtRequest),
                  type: AppTextTypeEnum.caption,
                  color: palette.onSurfaceMuted,
                ),
                if (note != null && note.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    note,
                    type: AppTextTypeEnum.caption,
                    color: palette.onSurfaceVariant,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          switch (request.status) {
            RedemptionStatusEnum.pending => AppStatusBadge.pending(
              label: label,
            ),
            RedemptionStatusEnum.approved => AppStatusBadge.approved(
              label: label,
            ),
            RedemptionStatusEnum.rejected => AppStatusBadge.rejected(
              label: label,
            ),
          },
        ],
      ),
    );
  }
}
