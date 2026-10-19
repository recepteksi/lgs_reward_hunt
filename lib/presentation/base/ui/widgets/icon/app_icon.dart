import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';

/// One of `AppIcons`, drawn at a size and tinted by the caller.
///
/// The tint is applied as a filter over `currentColor` markup rather than by
/// editing the SVG string, so an icon takes its colour the same way a `Text`
/// does — from whatever the theme handed the widget around it. An icon that
/// carried its own colour would be the one thing on a screen that did not
/// change when the student changed the accent.
///
/// [icon] is the markup, [size] the square it fills, and [color] the ink.
/// Icons here are decoration beside a label in every place they appear, so the
/// widget publishes no semantics of its own — the label is what a screen reader
/// should read, not "star" twice.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    required this.color,
    this.size = AppSizes.iconSize,
    super.key,
  });

  final String icon;

  final Color color;

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      icon,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
