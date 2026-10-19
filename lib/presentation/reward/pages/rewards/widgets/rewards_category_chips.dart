import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/reward_category_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_chip.dart';

/// The shop's filter: all rewards, or one category, in a row that scrolls
/// sideways when it does not fit.
///
/// [selected] is the category in force — null for all — and [onChanged] picks
/// another.
class RewardsCategoryChips extends StatelessWidget {
  const RewardsCategoryChips({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final RewardCategoryEnum? selected;

  final ValueChanged<RewardCategoryEnum?> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          AppChip(
            label: l10n.rewardCategoryAll,
            isSelected: selected == null,
            onTap: () => onChanged(null),
          ),
          for (final RewardCategoryEnum category
              in RewardCategoryEnum.values) ...<Widget>[
            const SizedBox(width: AppSpacing.sm),
            AppChip(
              label: rewardCategoryCopy(l10n, category),
              isSelected: category == selected,
              onTap: () => onChanged(category),
            ),
          ],
        ],
      ),
    );
  }
}
