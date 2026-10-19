import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/map/app_map_stop.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_caption.dart';

/// Section 07: the five kinds of stop on the path to the exam.
///
/// Shown on the map's own ground rather than on a card, because that ground is
/// half of what makes them legible — the locked stone reads as stone against
/// the map and as a disabled button against a white surface.
///
/// Size is the hierarchy here: today is the biggest object in the app by some
/// margin, and the specimen is the check that nothing else on a screen is
/// allowed to compete with it.
class UiKitMapSection extends StatelessWidget {
  const UiKitMapSection({super.key});

  static const int _todayStop = 3;

  static const int _lockedStop = 12;

  static const int _selectedStop = 9;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.mapBase,
        borderRadius: BorderRadius.circular(AppRadii.xxl),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          UiKitCaption('Stops'),
          SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.lg,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: <Widget>[
              AppMapStop.done(label: 'Tamamlandı'),
              AppMapStop.today(day: _todayStop, label: 'Bugün'),
              AppMapStop.special(label: 'Özel gün'),
              AppMapStop.locked(day: _lockedStop, label: 'Kilitli'),
              AppMapStop.selected(day: _selectedStop, label: 'Seçili'),
            ],
          ),
        ],
      ),
    );
  }
}
