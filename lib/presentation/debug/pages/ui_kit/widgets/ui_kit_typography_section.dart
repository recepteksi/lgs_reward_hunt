import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_caption.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_panel.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_specimen.dart';

/// Section 02: the type scale, each role shown at the size it ships at.
///
/// The specimens are the app's own strings rather than lorem: a balance, a day
/// heading, a task title, the sentence a student reads after choosing a reward.
/// A scale proved on invented words is a scale that has not met Turkish — the
/// dotless `ı`, the `ğ`, and the long compounds that decide whether a title
/// wraps on a 390 pixel screen.
class UiKitTypographySection extends StatelessWidget {
  const UiKitTypographySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiKitPanel(
      children: <Widget>[
        UiKitSpecimen(
          spec: 'display · 900/44 · balance, countdown',
          child: AppText('1.240', type: AppTextTypeEnum.display),
        ),
        UiKitSpecimen(
          spec: 'heading · 900/26 · screen title',
          child: AppText('Bugünün görevleri', type: AppTextTypeEnum.heading),
        ),
        UiKitSpecimen(
          spec: 'card title · 900/16',
          child: AppText('Kareköklü ifadeler', type: AppTextTypeEnum.title),
        ),
        UiKitSpecimen(
          spec: 'body · 800/14',
          child: AppText(
            'Ödülü seçtin, onay bekliyor.',
            type: AppTextTypeEnum.body,
          ),
        ),
        UiKitSpecimen(
          spec: 'meta · 700/12',
          child: AppText(
            '19:00 · 40 dk · Matematik',
            type: AppTextTypeEnum.meta,
          ),
        ),
        UiKitSpecimen(
          spec: 'label · 800/10 · tracked',
          child: UiKitCaption('Reward pool'),
        ),
      ],
    );
  }
}
