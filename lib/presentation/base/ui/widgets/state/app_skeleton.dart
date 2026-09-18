import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';

/// A placeholder in the exact shape of what is still loading.
///
/// It takes the size and radius of the component it stands in for, so nothing
/// jumps when the content arrives. It paints a flat surface; `AppShimmer`
/// above it adds the moving highlight. [width] null fills the available width.
/// [AppSkeleton.line] is one line of text at a type size; [AppSkeleton.circle]
/// is an avatar or a map stop.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    required this.height,
    this.width,
    this.radius = AppRadii.xs,
    super.key,
  });

  const AppSkeleton.line({
    this.width,
    double size = AppTypography.body,
    super.key,
  }) : height = size,
       radius = AppRadii.xs;

  const AppSkeleton.circle({required double size, super.key})
    : width = size,
      height = size,
      radius = AppRadii.round;

  final double? width;

  final double height;

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppPalette.of(context).surfaceHigh,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
