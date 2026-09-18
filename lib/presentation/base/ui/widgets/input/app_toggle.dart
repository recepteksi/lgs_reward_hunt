import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';

/// An on/off switch, in the app's colours.
///
/// Material's switch does the gesture and the motion; this gives it the
/// palette — the primary track when on, the outline when off — so a switch
/// on the parent's pool reads the same in every accent. [value] is on or off,
/// [onChanged] flips it, and a null [onChanged] disables it while an answer is
/// on its way.
class AppToggle extends StatelessWidget {
  const AppToggle({required this.value, required this.onChanged, super.key});

  final bool value;

  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: palette.onPrimary,
      activeTrackColor: palette.primary,
      inactiveThumbColor: palette.surface,
      inactiveTrackColor: palette.outlineStrong,
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    );
  }
}
