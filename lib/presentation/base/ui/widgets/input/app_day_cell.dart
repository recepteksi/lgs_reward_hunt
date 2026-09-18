import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One day in a week strip.
///
/// A cell rather than a picker, because the strip that holds seven of them
/// belongs to the screen: a parent planning tasks scrolls weeks, a child
/// looking at their own week does not, and a widget that owned the row would
/// have to be told which of those it was in.
///
/// [weekday] is the two or three letter name above, [day] the date below.
/// [isSelected] fills the cell in the primary — the same convention as
/// `AppChip`, because they are the same question asked about a different noun.
class AppDayCell extends StatelessWidget {
  const AppDayCell({
    required this.weekday,
    required this.day,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String weekday;

  final int day;

  final bool isSelected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Semantics(
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: AppSizes.dayCell,
          decoration: BoxDecoration(
            color: isSelected ? palette.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.md),
            border: Border.all(
              color: isSelected ? palette.primary : palette.outline,
              width: AppSizes.borderStrong,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppText(
                weekday,
                type: AppTextTypeEnum.label,
                color: isSelected ? palette.onPrimary : palette.onSurfaceMuted,
                style: const TextStyle(
                  letterSpacing: ValueConstants.zeroDouble,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText(
                '$day',
                type: AppTextTypeEnum.button,
                color: isSelected ? palette.onPrimary : palette.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
