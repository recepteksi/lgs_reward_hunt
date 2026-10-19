import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_opacity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One figure on a tinted tile: a label over it, a line under it.
///
/// The streak and the task total sit side by side on these, each in its own
/// tint — the streak in the reward's, the total in the primary's. [label],
/// [value] and [caption] are what it says; [background] and [ink] its colours,
/// the page's to choose from the palette.
class ProgressStatTile extends StatelessWidget {
  const ProgressStatTile({
    required this.label,
    required this.value,
    required this.caption,
    required this.background,
    required this.ink,
    super.key,
  });

  final String label;

  final int value;

  final String caption;

  final Color background;

  final Color ink;

  @override
  Widget build(BuildContext context) {
    final Color quiet = ink.withValues(alpha: AppOpacity.secondary);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.xxl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(label, type: AppTextTypeEnum.label, color: quiet),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            '$value',
            type: AppTextTypeEnum.heading,
            color: ink,
            weight: FontWeight.w900,
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(caption, type: AppTextTypeEnum.caption, color: quiet),
        ],
      ),
    );
  }
}
