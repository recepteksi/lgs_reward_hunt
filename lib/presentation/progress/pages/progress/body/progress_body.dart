import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/progress/enums/achievement_enum.dart';
import 'package:lgs_reward_hunt/domain/progress/read_models/progress_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/level_rank_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_level_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_week_chart.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_section_header.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/progress/pages/progress/items/progress_achievement_row.dart';
import 'package:lgs_reward_hunt/presentation/progress/pages/progress/widgets/progress_month_calendar.dart';
import 'package:lgs_reward_hunt/presentation/progress/pages/progress/widgets/progress_stat_tile.dart';

/// The progress tab's one body, top to bottom in the design's order.
///
/// Every figure is the value object's; this only lays them out. The week's
/// labels are the locale's short weekday names, Monday first, so they read
/// the way a Turkish week does. [progress] is what to show.
class ProgressBody extends StatelessWidget {
  const ProgressBody({required this.progress, super.key});

  final ProgressReadModel progress;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final String locale = Localizations.localeOf(context).toLanguageTag();
    final DateTime monday = DateTime(
      progress.today.year,
      progress.today.month,
      progress.today.day - progress.weekTodayIndex,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxxl,
      ),
      children: <Widget>[
        AppText(l10n.progressTitle, type: AppTextTypeEnum.heading),
        const SizedBox(height: AppSpacing.md),
        AppLevelCard(
          level: progress.level,
          levelLabel: l10n.progressLevelLabel,
          title: levelRankCopy(l10n, progress.rank),
          caption: l10n.progressLevelGap(progress.pointsToNextLevel),
          progress: progress.levelProgress,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            Expanded(
              child: ProgressStatTile(
                label: l10n.progressStreakLabel,
                value: progress.streakDays,
                caption: l10n.progressStreakCaption,
                background: palette.rewardSoft,
                ink: palette.rewardInk,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ProgressStatTile(
                label: l10n.progressTotalLabel,
                value: progress.completedTaskCount,
                caption: l10n.progressTotalCaption,
                background: palette.primaryContainer,
                ink: palette.onPrimaryContainer,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          radius: AppRadii.xxxl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppSectionHeader(title: l10n.progressWeekTitle),
              const SizedBox(height: AppSpacing.lg),
              AppWeekChart(
                values: progress.weekCompleted,
                labels: <String>[
                  for (
                    int offset = ValueConstants.zero;
                    offset < DateTime.daysPerWeek;
                    offset++
                  )
                    DateFormat.E(locale).format(
                      DateTime(monday.year, monday.month, monday.day + offset),
                    ),
                ],
                highlightedIndex: progress.weekTodayIndex,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          radius: AppRadii.xxxl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppSectionHeader(
                title: DateFormat.MMMM(locale).format(progress.today),
                trailing: l10n.progressMonthCaption,
              ),
              const SizedBox(height: AppSpacing.md),
              ProgressMonthCalendar(progress: progress),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          radius: AppRadii.xxxl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppSectionHeader(title: l10n.progressAchievementsTitle),
              const SizedBox(height: AppSpacing.md),
              for (final AchievementEnum achievement
                  in AchievementEnum.values) ...<Widget>[
                ProgressAchievementRow(
                  achievement: achievement,
                  progress: progress,
                ),
                if (achievement != AchievementEnum.values.last)
                  const SizedBox(height: AppSpacing.md),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
