import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One of two or three choices that share a row between them, as a wide tile.
///
/// Tiles rather than chips when the choices are few and made once — a child's
/// grade, a task's kind: each gets an equal share of the row and a thumb-sized
/// target. Selected is the primary container with a primary outline; a chip,
/// by contrast, is a filter in a row of many.
///
/// [label] is the choice's words, [isSelected] whether it is chosen and
/// [onTap] choosing it. Lay tiles out in `Expanded`s so they split the row.
class AppOptionTile extends StatelessWidget {
  const AppOptionTile({
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
        child: AnimatedContainer(
          duration: kThemeAnimationDuration,
          height: AppSizes.buttonHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? palette.primaryContainer : palette.surface,
            borderRadius: BorderRadius.circular(AppRadii.md),
            border: Border.all(
              color: isSelected ? palette.primary : palette.outlineStrong,
              width: AppSizes.borderStrong,
            ),
          ),
          child: AppText(
            label,
            type: AppTextTypeEnum.button,
            weight: FontWeight.w800,
            color: isSelected
                ? palette.onPrimaryContainer
                : palette.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
