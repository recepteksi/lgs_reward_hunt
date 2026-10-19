import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/progress/enums/progress_day_status_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One day on the month strip: filled primary when finished, filled reward
/// when it is today, quiet otherwise. [day] is the date, [status] how it reads.
class ProgressMonthDayCell extends StatelessWidget {
  const ProgressMonthDayCell({
    required this.day,
    required this.status,
    super.key,
  });

  final int day;

  final ProgressDayStatusEnum status;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: switch (status) {
          ProgressDayStatusEnum.complete => palette.primary,
          ProgressDayStatusEnum.today => palette.reward,
          ProgressDayStatusEnum.open => palette.surfaceHigh,
        },
        borderRadius: BorderRadius.circular(AppRadii.sm),
        border: status == ProgressDayStatusEnum.today
            ? Border.all(color: palette.rewardEdge, width: AppSizes.borderThick)
            : null,
      ),
      child: AppText(
        '$day',
        type: AppTextTypeEnum.caption,
        weight: FontWeight.w800,
        color: switch (status) {
          ProgressDayStatusEnum.complete => palette.onPrimary,
          ProgressDayStatusEnum.today => palette.onReward,
          ProgressDayStatusEnum.open => palette.onSurfaceMuted,
        },
      ),
    );
  }
}
