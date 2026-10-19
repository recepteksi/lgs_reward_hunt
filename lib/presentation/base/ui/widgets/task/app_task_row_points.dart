import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row_state_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The points pill at the tail of the row.
class AppTaskRowPoints extends StatelessWidget {
  const AppTaskRowPoints({super.key, required this.label, required this.state});

  final String label;

  final AppTaskRowStateEnum state;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: switch (state) {
          AppTaskRowStateEnum.pending => palette.rewardSoft,
          AppTaskRowStateEnum.done => palette.reward,
          AppTaskRowStateEnum.locked => palette.surfaceHigh,
        },
        borderRadius: BorderRadius.circular(AppRadii.round),
      ),
      child: AppText(
        label,
        type: AppTextTypeEnum.meta,
        weight: FontWeight.w900,
        color: switch (state) {
          AppTaskRowStateEnum.pending => palette.rewardInk,
          AppTaskRowStateEnum.done => palette.onReward,
          AppTaskRowStateEnum.locked => palette.onSurfaceMuted,
        },
      ),
    );
  }
}
