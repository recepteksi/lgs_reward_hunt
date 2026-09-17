import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/study_path/enums/study_stop_status_enum.dart';
import 'package:lgs_reward_hunt/domain/study_path/read_models/study_stop_read_model.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/clock_time_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/task_category_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_progress_ring.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/widgets/home_day_complete_banner.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/widgets/home_locked_day_card.dart';

/// The sheet over the bottom of the map: the selected day, and its tasks.
///
/// A `DraggableScrollableSheet` that rests at a peek — the day's name, how far
/// it has got, the first tasks — and is dragged up to show the whole day,
/// snapping between the two. The list scrolls inside it once it is open.
///
/// What the day shows depends on where it stands. Today's tasks can be ticked
/// — tapping a pending one calls [onComplete], and a task already done cannot
/// be un-ticked, because its points have been paid. A day gone by shows what
/// was done and what was not, and nothing can be ticked. A day to come shows a
/// locked card with what it will hold. A finished day ends with the banner.
///
/// [stop] is the day. [busyTaskId] is a task being ticked, which cannot be
/// tapped again until the answer comes. [failure] is a refused tick, shown at
/// the top of the list.
class HomeDaySheet extends StatelessWidget {
  const HomeDaySheet({
    required this.stop,
    required this.onComplete,
    this.busyTaskId,
    this.failure,
    super.key,
  });

  static const double _peek = 0.38;

  static const double _open = 0.86;

  static const double _handleWidth = 44;

  static const double _handleHeight = 5;

  final StudyStopReadModel stop;

  final ValueChanged<String> onComplete;

  final String? busyTaskId;

  final Failure? failure;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);
    final String locale = Localizations.localeOf(context).toLanguageTag();
    final String date = DateFormat.MMMMEEEEd(locale).format(stop.day);
    final Failure? failure = this.failure;
    final bool isUpcoming = stop.status == StudyStopStatusEnum.upcoming;

    final String title = switch (stop.status) {
      StudyStopStatusEnum.today =>
        stop.isComplete ? l10n.mapSheetTodayDone : l10n.mapSheetToday,
      StudyStopStatusEnum.passed || StudyStopStatusEnum.upcoming =>
        stop.isSpecial ? l10n.mapSheetSpecial(date) : l10n.mapSheetDay(date),
    };
    final String subtitle = isUpcoming
        ? l10n.mapSheetUpcoming
        : l10n.mapSheetProgress(
            stop.completedCount,
            stop.tasks.length,
            stop.totalPoints,
          );

    return DraggableScrollableSheet(
      initialChildSize: _peek,
      minChildSize: _peek,
      maxChildSize: _open,
      snap: true,
      builder: (BuildContext context, ScrollController scroll) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadii.xxxl),
            ),
            border: Border(
              top: BorderSide(color: palette.outline, width: AppSizes.border),
            ),
          ),
          child: ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.xxxl,
            ),
            children: <Widget>[
              Center(
                child: Container(
                  width: _handleWidth,
                  height: _handleHeight,
                  decoration: BoxDecoration(
                    color: palette.outlineStrong,
                    borderRadius: BorderRadius.circular(AppRadii.round),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AppText(
                          title,
                          type: AppTextTypeEnum.title,
                          weight: FontWeight.w900,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AppText(
                          subtitle,
                          type: AppTextTypeEnum.meta,
                          color: palette.onSurfaceMuted,
                        ),
                      ],
                    ),
                  ),
                  if (!isUpcoming && stop.hasTasks)
                    AppProgressRing(
                      completed: stop.completedCount,
                      total: stop.tasks.length,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              if (failure != null) ...<Widget>[
                AppText(
                  failureCopy(l10n, failure),
                  type: AppTextTypeEnum.caption,
                  color: palette.errorInk,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (isUpcoming)
                HomeLockedDayCard(stop: stop)
              else if (!stop.hasTasks)
                AppText(
                  l10n.mapSheetEmpty,
                  type: AppTextTypeEnum.body,
                  color: palette.onSurfaceMuted,
                )
              else
                for (final TaskEntity task in stop.tasks) ...<Widget>[
                  _row(l10n, task),
                  const SizedBox(height: AppSpacing.sm),
                ],
              if (stop.isComplete) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                HomeDayCompleteBanner(points: stop.earnedPoints),
              ],
            ],
          ),
        );
      },
    );
  }

  AppTaskRow _row(AppL10n l10n, TaskEntity task) {
    final String title = taskCategoryCopy(l10n, task.category);
    final String meta = l10n.taskMeta(
      task.title,
      clockTimeCopy(task.scheduledAt.hour, task.scheduledAt.minute),
      task.durationMinutes,
    );

    if (task.isCompleted) {
      return AppTaskRow.done(title: title, meta: meta, points: task.points);
    }
    if (!stop.canComplete) {
      return AppTaskRow.locked(title: title, meta: meta, points: task.points);
    }
    return AppTaskRow.pending(
      title: title,
      meta: meta,
      points: task.points,
      onTap: busyTaskId == null ? () => onComplete(task.id) : null,
    );
  }
}
