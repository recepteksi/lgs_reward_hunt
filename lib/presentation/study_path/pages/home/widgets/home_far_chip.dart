import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// How much of the road is left past the last stop the map draws.
///
/// The map draws a few weeks of stops and dashes the rest of the way to the
/// exam; this chip on the dashes is the count, so the distance is honest
/// without being three hundred stops tall. [days] is that count.
class HomeFarChip extends StatelessWidget {
  const HomeFarChip({required this.days, super.key});

  final int days;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: palette.rewardContainer,
        borderRadius: BorderRadius.circular(AppRadii.round),
        border: Border.all(color: palette.mapLine, width: AppSizes.border),
      ),
      child: AppText(
        AppL10n.of(context).mapStopsAhead(days),
        type: AppTextTypeEnum.caption,
        color: palette.rewardInk,
        weight: FontWeight.w900,
      ),
    );
  }
}
