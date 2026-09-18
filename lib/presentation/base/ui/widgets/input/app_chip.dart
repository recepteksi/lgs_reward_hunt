import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// A filter, in a row of filters.
///
/// Selected is a fill, not a tick or a heavier border: in a horizontal row the
/// eye finds a block of colour before it finds anything else, and the whole job
/// of this control is to say which of six words is currently in force.
///
/// [label] is the word, [isSelected] whether it is in force, and [onTap] what
/// to do about it. It is 36 tall — under the 44 minimum, which is why chips are
/// always in a row with generous spacing around them and never the only way to
/// reach something.
class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;

  final bool isSelected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: AppSizes.chip,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? palette.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.round),
            border: Border.all(
              color: isSelected ? palette.primary : palette.outlineStrong,
              width: AppSizes.borderStrong,
            ),
          ),
          child: AppText(
            label,
            type: AppTextTypeEnum.badge,
            weight: FontWeight.w800,
            color: isSelected ? palette.onPrimary : palette.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
