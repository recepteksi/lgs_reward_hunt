import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_draft_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/reward_category_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/reward_category_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_icon_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/reward/app_reward_card_state_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/reward/app_reward_category_tile.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row_points.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row_state_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/reward_setup/widgets/reward_setup_reward_editor.dart';

/// One reward of the pool: a summary row that opens into its editor.
///
/// Closed, it reads like the shop card it will become — the category's glyph,
/// the name, the category, the price — with a cross to delete it. Tapping the
/// text opens the editor under it, and the open reward is outlined in the
/// primary colour.
///
/// [reward] is the row, [isOpen] whether its editor shows, [onToggle] opens or
/// closes it, [onChanged] hands back the edited reward, [onRemove] deletes it.
class RewardSetupRewardRow extends StatelessWidget {
  const RewardSetupRewardRow({
    required this.reward,
    required this.isOpen,
    required this.onToggle,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final RewardDraftEntity reward;

  final bool isOpen;

  final VoidCallback onToggle;

  final ValueChanged<RewardDraftEntity> onChanged;

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);

    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(
          color: isOpen ? palette.primary : palette.outline,
          width: AppSizes.borderStrong,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppSpacing.md,
              top: AppSpacing.sm,
              bottom: AppSpacing.sm,
            ),
            child: Row(
              children: <Widget>[
                AppRewardCategoryTile(
                  icon: rewardCategoryIcon(reward.category),
                  state: AppRewardCardStateEnum.available,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: GestureDetector(
                    onTap: onToggle,
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AppText(
                          reward.hasName
                              ? reward.name
                              : l10n.rewardSetupNameHint,
                          type: AppTextTypeEnum.body,
                          weight: FontWeight.w800,
                          color: reward.hasName
                              ? palette.onSurface
                              : palette.onSurfaceMuted,
                          maxLines: ValueConstants.one,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AppText(
                          rewardCategoryCopy(l10n, reward.category),
                          type: AppTextTypeEnum.caption,
                          color: palette.onSurfaceMuted,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppTaskRowPoints(
                  label: l10n.taskPointsLocked(reward.cost),
                  state: AppTaskRowStateEnum.pending,
                ),
                AppIconButton.plain(
                  icon: AppIcons.close,
                  semanticLabel: l10n.rewardSetupRemove,
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
          if (isOpen)
            RewardSetupRewardEditor(
              reward: reward,
              onChanged: onChanged,
              onDone: onToggle,
            ),
        ],
      ),
    );
  }
}
