import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';

/// One end of the stepper.
///
/// The minus is the forward chevron turned around rather than a glyph of its
/// own: the icon set has no minus, and a hyphen set in the body face is a
/// different weight from everything beside it.
class AppStepperButton extends StatelessWidget {
  const AppStepperButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.background,
    required this.foreground,
    required this.size,
    required this.onPressed,
    this.quarterTurns = ValueConstants.zero,
  });

  final String icon;

  final String semanticLabel;

  final Color background;

  final Color foreground;

  final double size;

  final VoidCallback? onPressed;

  final int quarterTurns;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticLabel,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadii.sm),
          child: SizedBox.square(
            dimension: size,
            child: Center(
              child: RotatedBox(
                quarterTurns: quarterTurns,
                child: AppIcon(
                  icon,
                  color: foreground,
                  size: AppSizes.iconSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
