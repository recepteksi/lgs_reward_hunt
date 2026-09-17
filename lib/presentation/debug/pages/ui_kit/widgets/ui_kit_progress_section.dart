import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_level_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_progress_ring.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/progress/app_week_chart.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_section_header.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_caption.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_panel.dart';

/// Section 08: the three ways the app shows progress.
///
/// The ring appears twice, at three of four and at four of four, because the
/// second one is the app's entire reward for finishing a day: the ring a
/// student has been watching turns from the brand colour to the reward colour
/// and nothing else happens. A specimen that only showed the incomplete state
/// would hide the moment the component exists for.
class UiKitProgressSection extends StatelessWidget {
  const UiKitProgressSection({super.key});

  static const int _doneToday = 3;

  static const int _totalToday = 4;

  static const int _level = 4;

  static const double _levelProgress = 0.64;

  static const List<int> _weekValues = <int>[3, 4, 2, 4, 4, 1, 0];

  static const List<String> _weekLabels = <String>[
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
    'Paz',
  ];

  static const int _todayIndex = 3;

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        UiKitPanel(
          children: <Widget>[
            UiKitCaption('Day ring'),
            Row(
              children: <Widget>[
                AppProgressRing(completed: _doneToday, total: _totalToday),
                SizedBox(width: AppSpacing.xl),
                AppProgressRing(completed: _totalToday, total: _totalToday),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: AppText(
                    'The ring turns the reward colour once the day is complete.',
                    type: AppTextTypeEnum.meta,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        AppLevelCard(
          level: _level,
          title: 'Kararlı avcı',
          caption: 'Sonraki seviyeye 120 puan',
          progress: _levelProgress,
          levelLabel: 'SEVİYE',
        ),
        SizedBox(height: AppSpacing.md),
        UiKitPanel(
          children: <Widget>[
            UiKitCaption('This week'),
            AppSectionHeader(title: 'Bu hafta', trailing: '4 / 7 gün'),
            AppWeekChart(
              values: _weekValues,
              labels: _weekLabels,
              highlightedIndex: _todayIndex,
            ),
          ],
        ),
      ],
    );
  }
}
