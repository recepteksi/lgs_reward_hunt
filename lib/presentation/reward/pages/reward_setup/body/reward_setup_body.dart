import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/reward/cubit/reward_setup/reward_setup_cubit.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_draft_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/value_objects/reward_pool_value_object.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_dashed_add_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_header.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_step_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/reward_setup/items/reward_setup_reward_row.dart';

/// The reward setup step's one body: the summary, the pool, and finishing.
///
/// Which reward is open is kept here, one at a time, and a reward just added
/// opens. The summary is the pool's own count and price range. The primary
/// action ends setup; it cannot be pressed on an empty pool, says so, and
/// waits while [isSaving]. A refused save shows [failure] above it.
class RewardSetupBody extends StatefulWidget {
  const RewardSetupBody({
    required this.pool,
    this.isSaving = false,
    this.failure,
    super.key,
  });

  final RewardPoolValueObject pool;

  final bool isSaving;

  final Failure? failure;

  @override
  State<RewardSetupBody> createState() => _RewardSetupBodyState();
}

/// Holds which reward is open.
class _RewardSetupBodyState extends State<RewardSetupBody> {
  String? _openId;

  @override
  void didUpdateWidget(RewardSetupBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pool.rewards.length > oldWidget.pool.rewards.length) {
      _openId = widget.pool.rewards.last.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final RewardSetupCubit cubit = context.read<RewardSetupCubit>();
    final RewardPoolValueObject pool = widget.pool;
    final Failure? failure = widget.failure;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const AppSetupHeader(step: AppSetupStepEnum.rewards),
        const SizedBox(height: AppSpacing.xl),
        Expanded(
          child: ListView(
            children: <Widget>[
              AppText(l10n.rewardSetupTitle, type: AppTextTypeEnum.heading),
              const SizedBox(height: AppSpacing.sm),
              AppText(l10n.rewardSetupBody, type: AppTextTypeEnum.body),
              const SizedBox(height: AppSpacing.lg),
              AppText(
                pool.isEmpty
                    ? l10n.rewardSetupEmpty
                    : l10n.rewardSetupSummary(
                        pool.rewards.length,
                        pool.cheapest,
                        pool.dearest,
                      ),
                type: AppTextTypeEnum.meta,
                weight: FontWeight.w800,
                color: palette.onSurfaceMuted,
              ),
              const SizedBox(height: AppSpacing.md),
              for (final RewardDraftEntity reward in pool.rewards) ...<Widget>[
                RewardSetupRewardRow(
                  key: ValueKey<String>(reward.id),
                  reward: reward,
                  isOpen: reward.id == _openId,
                  onToggle: () => setState(
                    () => _openId = reward.id == _openId ? null : reward.id,
                  ),
                  onChanged: cubit.update,
                  onRemove: () => cubit.remove(reward.id),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              AppDashedAddButton(
                label: l10n.rewardSetupAdd,
                onPressed: cubit.add,
              ),
            ],
          ),
        ),
        if (failure != null) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          AppText(
            failureCopy(l10n, failure),
            type: AppTextTypeEnum.caption,
            color: palette.errorInk,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppButton.filled(
          label: pool.isEmpty
              ? l10n.rewardSetupNeedOne
              : l10n.rewardSetupFinish,
          isExpanded: true,
          onPressed: pool.isEmpty || widget.isSaving ? null : cubit.save,
        ),
      ],
    );
  }
}
