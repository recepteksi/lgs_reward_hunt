import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_progress_ring.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The second slide's picture: a sample day, drawn with the real task rows.
///
/// It is the day sheet in miniature, built from `AppTaskRow` and
/// `AppProgressRing` rather than a drawing of them, so what the parent is shown
/// here is exactly what the student will see — and it follows the accent.
/// Two of the four are done, which is the point being made: the list is
/// something you work down, not a wall.
///
/// Nothing here is data. The subjects are copy, and [_stop], [_doneCount] and
/// the four `_…Points` figures are the design's sample; the ring's total and
/// the day's points are worked out from the rows, so the header cannot
/// disagree with the list under it.
class IntroTasksArt extends StatelessWidget {
  const IntroTasksArt({super.key});

  static const int _stop = 3;

  static const int _mathPoints = 20;

  static const int _turkishPoints = 15;

  static const int _sciencePoints = 20;

  static const int _readingPoints = 10;

  static const int _doneCount = 2;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);
    final List<AppTaskRow> rows = <AppTaskRow>[
      AppTaskRow.done(
        title: l10n.introSampleMathTitle,
        meta: l10n.introSampleMathMeta,
        points: _mathPoints,
      ),
      AppTaskRow.done(
        title: l10n.introSampleTurkishTitle,
        meta: l10n.introSampleTurkishMeta,
        points: _turkishPoints,
      ),
      AppTaskRow.pending(
        title: l10n.introSampleScienceTitle,
        meta: l10n.introSampleScienceMeta,
        points: _sciencePoints,
      ),
      AppTaskRow.pending(
        title: l10n.introSampleReadingTitle,
        meta: l10n.introSampleReadingMeta,
        points: _readingPoints,
      ),
    ];
    final int total = rows.fold(
      ValueConstants.zero,
      (int sum, AppTaskRow row) => sum + row.points,
    );

    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppText(
                      l10n.introTasksTitle,
                      type: AppTextTypeEnum.title,
                      weight: FontWeight.w900,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppText(
                      l10n.introTasksMeta(_stop, total),
                      type: AppTextTypeEnum.meta,
                      color: palette.onSurfaceMuted,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              AppProgressRing(completed: _doneCount, total: rows.length),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final AppTaskRow row in rows) ...<Widget>[
            row,
            if (row != rows.last) const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
