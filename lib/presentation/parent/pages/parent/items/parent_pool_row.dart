import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/rules/reward_pool_rules.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/reward_category_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_stepper.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_toggle.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One reward in the parent's pool: on or off, its price, and a way out.
///
/// A reward switched off stays in the list, quieter, so it can be switched on
/// again. The price steps like the setup step's; each step is saved as it is
/// tapped. [reward] is the row; [onActiveChanged], [onCheaper], [onDearer] and
/// [onRemove] are its controls, null while an action is on its way.
class ParentPoolRow extends StatelessWidget {
  const ParentPoolRow({
    required this.reward,
    required this.onActiveChanged,
    required this.onCheaper,
    required this.onDearer,
    required this.onRemove,
    super.key,
  });

  final RewardEntity reward;

  final ValueChanged<bool>? onActiveChanged;

  final VoidCallback? onCheaper;

  final VoidCallback? onDearer;

  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);

    return AppCard(
      radius: AppRadii.xl,
      color: reward.isActive ? palette.surface : palette.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppText(
                      reward.name,
                      type: AppTextTypeEnum.body,
                      weight: FontWeight.w800,
                      color: reward.isActive
                          ? palette.onSurface
                          : palette.onSurfaceMuted,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppText(
                      l10n.parentRewardRowMeta(
                        rewardCategoryCopy(l10n, reward.category),
                        reward.isActive
                            ? l10n.parentRewardOn
                            : l10n.parentRewardOff,
                      ),
                      type: AppTextTypeEnum.caption,
                      color: palette.onSurfaceMuted,
                    ),
                  ],
                ),
              ),
              AppToggle(value: reward.isActive, onChanged: onActiveChanged),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              AppStepper(
                value: reward.cost,
                step: RewardPoolRules.costStep,
                minimum: RewardPoolRules.minCost,
                maximum: RewardPoolRules.maxCost,
                decreaseLabel: l10n.commonPointsDown,
                increaseLabel: l10n.commonPointsUp,
                onChanged: (int value) =>
                    value > reward.cost ? onDearer?.call() : onCheaper?.call(),
              ),
              const Spacer(),
              AppButton.text(label: l10n.parentRemove, onPressed: onRemove),
            ],
          ),
        ],
      ),
    );
  }
}
