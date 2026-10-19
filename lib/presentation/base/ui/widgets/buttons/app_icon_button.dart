import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_icon_button_tone_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';

/// A square button with an icon and no label.
///
/// It is 44 by 44 and never smaller: an icon button has no words to widen its
/// target, so it is the control most likely to fall under the minimum a thumb
/// can hit, and the design fixes the size rather than leaving it to padding.
///
/// [AppIconButton.tonal] is the affirmative one — add, confirm — and carries
/// the primary container behind it. The default is neutral, for the ones that
/// only move you somewhere: back, forward, refresh. [AppIconButton.plain] has
/// no ground at all and exists for a bar, where the bar is already the surface
/// and a second one behind the icon reads as a button stuck onto it.
///
/// [semanticLabel] is required because there is no visible text to read. An
/// icon button without one is a button a screen reader announces as nothing.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    super.key,
  }) : _tone = AppIconButtonToneEnum.neutral;

  const AppIconButton.tonal({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    super.key,
  }) : _tone = AppIconButtonToneEnum.tonal;

  const AppIconButton.plain({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    super.key,
  }) : _tone = AppIconButtonToneEnum.plain;

  final String icon;

  final String semanticLabel;

  final VoidCallback? onPressed;

  final AppIconButtonToneEnum _tone;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final bool isEnabled = onPressed != null;
    final Color foreground = !isEnabled
        ? palette.onSurfaceMuted
        : switch (_tone) {
            AppIconButtonToneEnum.tonal => palette.primary,
            AppIconButtonToneEnum.neutral => palette.onSurfaceVariant,
            AppIconButtonToneEnum.plain => palette.primary,
          };

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: semanticLabel,
      child: Material(
        color: switch (_tone) {
          AppIconButtonToneEnum.tonal => palette.primaryContainer,
          AppIconButtonToneEnum.neutral => palette.surfaceHigh,
          AppIconButtonToneEnum.plain => Colors.transparent,
        },
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppRadii.md),
          child: SizedBox.square(
            dimension: AppSizes.iconButton,
            child: Center(
              child: AppIcon(icon, color: foreground, size: AppSizes.iconSize),
            ),
          ),
        ),
      ),
    );
  }
}
