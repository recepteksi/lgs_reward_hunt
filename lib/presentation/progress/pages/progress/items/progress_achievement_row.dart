import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/progress/enums/achievement_enum.dart';
import 'package:lgs_reward_hunt/domain/progress/read_models/progress_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One badge: its glyph, its name and what it is for, and a tick once earned.
///
/// An unearned badge is shown quietly rather than hidden — like a locked
/// reward, a badge the child cannot see is one nobody works towards.
/// [achievement] is the badge, [progress] says whether it is earned.
class ProgressAchievementRow extends StatelessWidget {
  const ProgressAchievementRow({
    required this.achievement,
    required this.progress,
    super.key,
  });

  static const double _tick = 24;

  final AchievementEnum achievement;

  final ProgressReadModel progress;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);
    final bool earned = progress.isEarned(achievement);
    final int target = progress.achievementTarget(achievement);

    final (
      String icon,
      Color tile,
      Color glyph,
      String title,
      String body,
    ) = switch (achievement) {
      AchievementEnum.weekStreak => (
        AppIcons.flame,
        palette.primaryContainer,
        palette.onPrimaryContainer,
        l10n.achievementWeekStreakTitle(target),
        l10n.achievementWeekStreakBody,
      ),
      AchievementEnum.firstPracticeExam => (
        AppIcons.star,
        palette.rewardSoft,
        palette.rewardInk,
        l10n.achievementFirstPracticeTitle,
        l10n.achievementFirstPracticeBody,
      ),
      AchievementEnum.practiceMaster => (
        AppIcons.check,
        palette.surfaceHigh,
        palette.onSurfaceMuted,
        l10n.achievementPracticeMasterTitle,
        l10n.achievementPracticeMasterBody(
          target,
          progress.achievementProgress(achievement),
        ),
      ),
    };

    return Row(
      children: <Widget>[
        Container(
          width: AppSizes.iconTile,
          height: AppSizes.iconTile,
          decoration: BoxDecoration(
            color: earned ? tile : palette.surfaceHigh,
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          child: Center(
            child: AppIcon(
              icon,
              color: earned ? glyph : palette.onSurfaceMuted,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppText(
                title,
                type: AppTextTypeEnum.body,
                weight: FontWeight.w800,
                color: earned ? palette.onSurface : palette.onSurfaceMuted,
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText(
                body,
                type: AppTextTypeEnum.caption,
                color: palette.onSurfaceMuted,
              ),
            ],
          ),
        ),
        if (earned)
          Container(
            width: _tick,
            height: _tick,
            decoration: BoxDecoration(
              color: palette.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppIcon(
                AppIcons.check,
                color: palette.onPrimary,
                size: AppSizes.iconSizeSmall,
              ),
            ),
          ),
      ],
    );
  }
}
