import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_draft_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/rules/reward_pool_rules.dart';
import 'package:lgs_reward_hunt/domain/task/rules/draft_rules.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/reward_category_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_chip.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_stepper.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_text_field.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// A new reward for the pool: its name, category and price.
///
/// The fields are a `RewardDraftEntity` — the same one the setup step edits —
/// so the price is kept inside the pool's band here too. The add button waits
/// for a name. [onSubmit] hands the reward on and [onCancel] closes the form.
class ParentRewardForm extends StatefulWidget {
  const ParentRewardForm({
    required this.onSubmit,
    required this.onCancel,
    super.key,
  });

  static const String _newId = '${DraftRules.idPrefix}reward';

  final ValueChanged<RewardDraftEntity> onSubmit;

  final VoidCallback onCancel;

  @override
  State<ParentRewardForm> createState() => _ParentRewardFormState();
}

/// Holds the reward being written and its name field.
class _ParentRewardFormState extends State<ParentRewardForm> {
  final TextEditingController _name = TextEditingController();

  RewardDraftEntity _reward = RewardDraftEntity.draft(ParentRewardForm._newId);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);

    return AppCard(
      radius: AppRadii.xxl,
      border: BorderSide(color: palette.primary, width: AppSizes.borderStrong),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppText(
            l10n.parentNewReward,
            type: AppTextTypeEnum.title,
            weight: FontWeight.w900,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: l10n.rewardSetupName,
            hint: l10n.parentRewardNameHint,
            controller: _name,
            onChanged: (String value) =>
                setState(() => _reward = _reward.withName(value)),
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
                  isSelected: category == _reward.category,
                  onTap: () =>
                      setState(() => _reward = _reward.withCategory(category)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: AppText(
                  l10n.parentRewardCostLabel,
                  type: AppTextTypeEnum.label,
                ),
              ),
              AppStepper(
                value: _reward.cost,
                step: RewardPoolRules.costStep,
                minimum: RewardPoolRules.minCost,
                maximum: RewardPoolRules.maxCost,
                decreaseLabel: l10n.commonPointsDown,
                increaseLabel: l10n.commonPointsUp,
                onChanged: (int value) =>
                    setState(() => _reward = _reward.withCost(value)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: AppButton.outlined(
                  label: l10n.commonCancel,
                  isExpanded: true,
                  onPressed: widget.onCancel,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton.filled(
                  label: l10n.parentAddToPool,
                  isExpanded: true,
                  onPressed: _reward.hasName
                      ? () => widget.onSubmit(_reward)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
