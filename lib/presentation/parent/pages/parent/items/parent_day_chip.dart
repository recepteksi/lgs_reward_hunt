import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_opacity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One day of the parent's week strip: "Bugün", "Yarın" or the date, and the
/// weekday with how many tasks it holds.
///
/// [day] is the day, [today] what "Bugün" is measured from, [taskCount] its
/// tasks, [isSelected] fills it, and [onTap] selects it.
class ParentDayChip extends StatelessWidget {
  const ParentDayChip({
    required this.day,
    required this.today,
    required this.taskCount,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  static const double _width = 88;

  final DateTime day;

  final DateTime today;

  final int taskCount;

  final bool isSelected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);
    final String locale = Localizations.localeOf(context).toLanguageTag();
    final int offset = day.difference(today).inDays;
    final String label = switch (offset) {
      ValueConstants.zero => l10n.parentToday,
      ValueConstants.one => l10n.parentTomorrow,
      _ => DateFormat.MMMd(locale).format(day),
    };
    final Color ink = isSelected ? palette.onPrimary : palette.onSurface;

    return Semantics(
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: _width,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected ? palette.primary : palette.surface,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(
              color: isSelected ? palette.primary : palette.outline,
              width: AppSizes.borderStrong,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppText(
                label,
                type: AppTextTypeEnum.badge,
                weight: FontWeight.w900,
                color: ink,
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText(
                l10n.parentDayChipSub(
                  DateFormat.E(locale).format(day),
                  taskCount,
                ),
                type: AppTextTypeEnum.label,
                color: ink.withValues(alpha: AppOpacity.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
