import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/parent/cubit/parent/parent_cubit.dart';
import 'package:lgs_reward_hunt/domain/parent/read_models/parent_dashboard_read_model.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_draft_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_section_header.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/items/parent_pool_row.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/items/parent_preset_chip.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/widgets/parent_reward_form.dart';

/// The reward pool, as the parent manages it.
///
/// A button that opens the new-reward form, and under it the suggested rewards
/// one tap adds; then every reward, each with its switch, its price and a way
/// to remove it. Whether the form is open is kept here. [dashboard] supplies
/// the pool and the suggestions; [isBusy] disables changes while one is on
/// its way.
class ParentPoolSection extends StatefulWidget {
  const ParentPoolSection({
    required this.dashboard,
    required this.isBusy,
    super.key,
  });

  final ParentDashboardReadModel dashboard;

  final bool isBusy;

  @override
  State<ParentPoolSection> createState() => _ParentPoolSectionState();
}

/// Holds whether the new-reward form is open.
class _ParentPoolSectionState extends State<ParentPoolSection> {
  bool _isFormOpen = false;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final ParentCubit cubit = context.read<ParentCubit>();
    final ParentDashboardReadModel dashboard = widget.dashboard;
    final bool isBusy = widget.isBusy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (_isFormOpen)
          ParentRewardForm(
            onCancel: () => setState(() => _isFormOpen = false),
            onSubmit: (RewardDraftEntity reward) {
              setState(() => _isFormOpen = false);
              cubit.addReward(
                name: reward.name,
                category: reward.category,
                cost: reward.cost,
              );
            },
          )
        else ...<Widget>[
          AppButton.filled(
            label: l10n.parentAddReward,
            icon: AppIcons.plus,
            isExpanded: true,
            onPressed: isBusy ? null : () => setState(() => _isFormOpen = true),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppText(l10n.parentPresetsLabel, type: AppTextTypeEnum.label),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final RewardDraftEntity preset in dashboard.presets)
                ParentPresetChip(
                  preset: preset,
                  onTap: isBusy
                      ? null
                      : () => cubit.addReward(
                          name: preset.name,
                          category: preset.category,
                          cost: preset.cost,
                        ),
                ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        AppSectionHeader(
          title: l10n.parentPoolTitle,
          trailing: l10n.parentPoolOpen(dashboard.openRewards),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final RewardEntity reward in dashboard.rewards) ...<Widget>[
          ParentPoolRow(
            reward: reward,
            onActiveChanged: isBusy
                ? null
                : (bool value) =>
                      cubit.setRewardActive(reward, isActive: value),
            onCheaper: isBusy ? null : () => cubit.bumpCost(reward, up: false),
            onDearer: isBusy ? null : () => cubit.bumpCost(reward, up: true),
            onRemove: isBusy ? null : () => cubit.removeReward(reward.id),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
