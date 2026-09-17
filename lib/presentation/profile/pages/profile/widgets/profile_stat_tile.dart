import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One figure on the profile, centred on a plain tile with its word under it.
///
/// [value] is the figure, [label] what it counts, [ink] the figure's colour —
/// the reward ink for points, the primary for the streak, plain for tasks.
class ProfileStatTile extends StatelessWidget {
  const ProfileStatTile({
    required this.value,
    required this.label,
    required this.ink,
    super.key,
  });

  final int value;

  final String label;

  final Color ink;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: palette.outline, width: AppSizes.border),
      ),
      child: Column(
        children: <Widget>[
          AppText(
            '$value',
            type: AppTextTypeEnum.balance,
            color: ink,
            weight: FontWeight.w900,
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(
            label,
            type: AppTextTypeEnum.caption,
            color: palette.onSurfaceMuted,
          ),
        ],
      ),
    );
  }
}
