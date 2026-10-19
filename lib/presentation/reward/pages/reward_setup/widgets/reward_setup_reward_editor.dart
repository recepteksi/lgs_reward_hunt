import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_draft_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/rules/reward_pool_rules.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/reward_category_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_chip.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_stepper.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_text_field.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The editor under an open reward: its name, its category, its price.
///
/// Every control hands back a new reward built by the reward's own `with…`
/// edit; the price moves by `RewardPoolRules.costStep` inside the pool's band.
/// The name field keeps its own controller, so typing is not reset each time
/// the pool comes back from the Cubit. [reward] is the row, [onChanged] the
/// edit, [onDone] closes it.
class RewardSetupRewardEditor extends StatefulWidget {
  const RewardSetupRewardEditor({
    required this.reward,
    required this.onChanged,
    required this.onDone,
    super.key,
  });

  final RewardDraftEntity reward;

  final ValueChanged<RewardDraftEntity> onChanged;

  final VoidCallback onDone;

  @override
  State<RewardSetupRewardEditor> createState() =>
      _RewardSetupRewardEditorState();
}

/// Holds the name being typed.
class _RewardSetupRewardEditorState extends State<RewardSetupRewardEditor> {
  late final TextEditingController _name = TextEditingController(
    text: widget.reward.name,
  );

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final RewardDraftEntity reward = widget.reward;
    final ValueChanged<RewardDraftEntity> onChanged = widget.onChanged;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppTextField(
            label: l10n.rewardSetupName,
            hint: l10n.rewardSetupNameHint,
            controller: _name,
            onChanged: (String value) => onChanged(reward.withName(value)),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppText(l10n.rewardSetupCategory, type: AppTextTypeEnum.label),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final RewardCategoryEnum category
                  in RewardCategoryEnum.values)
                AppChip(
                  label: rewardCategoryCopy(l10n, category),
                  isSelected: category == reward.category,
                  onTap: () => onChanged(reward.withCategory(category)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: AppText(
                  l10n.rewardSetupCost,
                  type: AppTextTypeEnum.label,
                ),
              ),
              AppStepper(
                value: reward.cost,
                step: RewardPoolRules.costStep,
                minimum: RewardPoolRules.minCost,
                maximum: RewardPoolRules.maxCost,
                decreaseLabel: l10n.commonPointsDown,
                increaseLabel: l10n.commonPointsUp,
                onChanged: (int value) => onChanged(reward.withCost(value)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.tonal(
            label: l10n.commonDone,
            isExpanded: true,
            onPressed: widget.onDone,
          ),
        ],
      ),
    );
  }
}
