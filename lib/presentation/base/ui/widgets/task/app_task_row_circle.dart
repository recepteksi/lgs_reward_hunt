import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row_state_enum.dart';

/// The circle at the head of the row: empty, ticked, or holding a padlock.
class AppTaskRowCircle extends StatelessWidget {
  const AppTaskRowCircle({super.key, required this.state});

  final AppTaskRowStateEnum state;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Container(
      width: AppSizes.taskCheck,
      height: AppSizes.taskCheck,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: switch (state) {
          AppTaskRowStateEnum.pending => Colors.transparent,
          AppTaskRowStateEnum.done => palette.primary,
          AppTaskRowStateEnum.locked => palette.surfaceHigh,
        },
        border: Border.all(
          color: switch (state) {
            AppTaskRowStateEnum.pending => palette.outlineStrong,
            AppTaskRowStateEnum.done => palette.primary,
            AppTaskRowStateEnum.locked => palette.outline,
          },
          width: AppSizes.checkBorder,
        ),
      ),
      child: switch (state) {
        AppTaskRowStateEnum.pending => null,
        AppTaskRowStateEnum.done => Center(
          child: AppIcon(
            AppIcons.check,
            color: palette.onPrimary,
            size: AppSizes.iconSizeSmall,
          ),
        ),
        AppTaskRowStateEnum.locked => Center(
          child: AppIcon(
            AppIcons.locked,
            color: palette.onSurfaceMuted,
            size: AppSizes.iconSizeSmall,
          ),
        ),
      },
    );
  }
}
