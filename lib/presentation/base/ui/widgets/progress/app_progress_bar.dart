import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';

/// A filled track, five pixels tall.
///
/// It appears under a reward's price and beside a level, and in both places it
/// answers the same question — how much of the way there — so it is one widget
/// rather than a decoration each of them draws. Full is not a special case: a
/// reward that can be afforded shows a complete bar, which is what makes the
/// row of cards in the shop readable at a glance.
///
/// [progress] is clamped rather than asserted, because it is arithmetic on
/// points the user is changing, and a value slightly over one should paint a
/// full bar rather than crash a screen.
///
/// [color] defaults to the reward colour — most of these bars are about points.
/// [trackColor] exists for the one card whose ground is already the success
/// container, where the usual track would disappear into it.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    required this.progress,
    this.color,
    this.trackColor,
    this.height = AppSizes.progressBar,
    super.key,
  });

  final double progress;

  final Color? color;

  final Color? trackColor;

  final double height;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.round),
      child: SizedBox(
        height: height,
        child: ColoredBox(
          color: trackColor ?? palette.surfaceHigh,
          child: FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: progress.clamp(
              ValueConstants.zeroDouble,
              ValueConstants.oneDouble,
            ),
            child: ColoredBox(color: color ?? palette.reward),
          ),
        ),
      ),
    );
  }
}
