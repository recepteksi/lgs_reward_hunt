import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/progress/read_models/progress_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/progress/pages/progress/items/progress_month_day_cell.dart';

/// This month, seven days to a row, with the finished days filled.
///
/// The first row is not offset to a weekday: it is a strip of numbered days,
/// not a wall calendar, and the question it answers is how many days were
/// finished, not what day of the week the first fell on. [progress] says how
/// each day reads.
class ProgressMonthCalendar extends StatelessWidget {
  const ProgressMonthCalendar({required this.progress, super.key});

  final ProgressReadModel progress;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: DateTime.daysPerWeek,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        for (final DateTime day in progress.monthDays)
          ProgressMonthDayCell(day: day.day, status: progress.dayStatus(day)),
      ],
    );
  }
}
