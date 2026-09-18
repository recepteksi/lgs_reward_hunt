import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/badge/app_points_badge.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/badge/app_status_badge.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/badge/app_streak_badge.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_caption.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_panel.dart';

/// Section 04: the pills — points, status, streak.
///
/// The two points badges are the same number at two weights: quiet on a bar or
/// a row where it is one of many, solid on a screen that is about the balance
/// itself. Seeing them side by side is the check that they still read as the
/// same thing.
///
/// The streak specimen is shown at seven days and at one, because at one it is
/// supposed to disappear entirely — a rule that is invisible in a design tool
/// and obvious here.
class UiKitBadgesSection extends StatelessWidget {
  const UiKitBadgesSection({super.key});

  static const int _balanceSmall = 480;

  static const int _balanceLarge = 1240;

  static const int _streakDays = 7;

  static const int _singleDay = 1;

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        UiKitPanel(
          children: <Widget>[
            UiKitCaption('Points · small / large'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AppPointsBadge(points: _balanceSmall),
                SizedBox(width: AppSpacing.md),
                AppPointsBadge.prominent(points: _balanceLarge),
              ],
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        UiKitPanel(
          children: <Widget>[
            UiKitCaption('Status'),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                AppStatusBadge.pending(label: 'Onay bekliyor'),
                AppStatusBadge.approved(label: 'Onaylandı'),
                AppStatusBadge.rejected(label: 'Reddedildi'),
                AppStatusBadge.locked(label: 'Kilitli'),
              ],
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        UiKitPanel(
          children: <Widget>[
            UiKitCaption('Streak · shown from two days'),
            Row(
              children: <Widget>[
                AppStreakBadge(days: _streakDays),
                SizedBox(width: AppSpacing.md),
                AppStreakBadge(days: _singleDay),
              ],
            ),
            AppText(
              'The one-day streak on the right draws nothing at all.',
              type: AppTextTypeEnum.meta,
            ),
          ],
        ),
      ],
    );
  }
}
