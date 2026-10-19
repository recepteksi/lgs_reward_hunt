import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_option_tile.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/parent_tab_enum.dart';

/// The two halves of the parent's side, side by side.
///
/// [selected] is the half showing and [onChanged] switches it.
class ParentTabSwitch extends StatelessWidget {
  const ParentTabSwitch({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final ParentTabEnum selected;

  final ValueChanged<ParentTabEnum> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: palette.outline, width: AppSizes.border),
      ),
      child: Row(
        children: <Widget>[
          for (final ParentTabEnum tab in ParentTabEnum.values) ...<Widget>[
            if (tab != ParentTabEnum.values.first)
              const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: AppOptionTile(
                label: switch (tab) {
                  ParentTabEnum.approvals => l10n.parentTabApprovals,
                  ParentTabEnum.pool => l10n.parentTabPool,
                },
                isSelected: tab == selected,
                onTap: () => onChanged(tab),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
