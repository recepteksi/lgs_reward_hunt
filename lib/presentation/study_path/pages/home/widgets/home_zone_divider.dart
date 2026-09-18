import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// A hairline across the map with the name of the stretch that starts above
/// it.
///
/// Every `StudyMapRules.stopsPerZone` stops the road gets a new name, so a
/// long way reads as a handful of stretches rather than one endless climb.
/// [number] is the stretch, counting from one at the bottom.
class HomeZoneDivider extends StatelessWidget {
  const HomeZoneDivider({required this.number, super.key});

  final int number;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return IgnorePointer(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(height: AppSizes.border, color: palette.mapLine),
          ),
          const SizedBox(width: AppSpacing.md),
          AppText(
            AppL10n.of(context).mapZone(number),
            type: AppTextTypeEnum.label,
            color: palette.mapLockedInk,
            weight: FontWeight.w900,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Container(height: AppSizes.border, color: palette.mapLine),
          ),
        ],
      ),
    );
  }
}
