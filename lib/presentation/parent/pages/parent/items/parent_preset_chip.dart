import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_draft_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// A suggested reward, name and price, that one tap adds to the pool.
///
/// [preset] is the suggestion and [onTap] adds it — null while an action is on
/// its way.
class ParentPresetChip extends StatelessWidget {
  const ParentPresetChip({
    required this.preset,
    required this.onTap,
    super.key,
  });

  final RewardDraftEntity preset;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Semantics(
      button: true,
      label: preset.name,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: AppSizes.chip,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(AppRadii.round),
            border: Border.all(color: palette.outline, width: AppSizes.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppText(
                preset.name,
                type: AppTextTypeEnum.meta,
                weight: FontWeight.w700,
                color: palette.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              AppText(
                AppL10n.of(context).taskPointsLocked(preset.cost),
                type: AppTextTypeEnum.caption,
                weight: FontWeight.w900,
                color: palette.rewardInk,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
