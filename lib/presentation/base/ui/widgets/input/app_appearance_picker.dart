import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/accent_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/theme_mode_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The two appearance settings as controls: brightness, and the accent.
///
/// A segmented row for the three brightness answers and a row of swatches for
/// the five colour ways, each swatch drawn in its own primary for the current
/// brightness — so the choice is shown, not named. It is the profile page's
/// appearance card and the top of the kit sheet, where it re-themes every
/// specimen below it.
///
/// [mode] and [accent] are the current choices, [onModeChanged] and
/// [onAccentChanged] the taps.
class AppAppearancePicker extends StatelessWidget {
  const AppAppearancePicker({
    required this.mode,
    required this.accent,
    required this.onModeChanged,
    required this.onAccentChanged,
    super.key,
  });

  static const double _swatch = 36;

  final ThemeMode mode;

  final AppAccentEnum accent;

  final ValueChanged<ThemeMode> onModeChanged;

  final ValueChanged<AppAccentEnum> onAccentChanged;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final Brightness brightness = Theme.of(context).brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: palette.surfaceHigh,
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Row(
              children: <Widget>[
                for (final ThemeMode option in ThemeMode.values)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onModeChanged(option),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: AppSizes.chip,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: option == mode
                              ? palette.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppRadii.sm),
                        ),
                        child: AppText(
                          themeModeCopy(l10n, option),
                          type: AppTextTypeEnum.badge,
                          weight: FontWeight.w800,
                          color: option == mode
                              ? palette.onPrimary
                              : palette.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            for (final AppAccentEnum option
                in AppAccentEnum.values) ...<Widget>[
              Semantics(
                button: true,
                selected: option == accent,
                label: accentCopy(l10n, option),
                child: GestureDetector(
                  onTap: () => onAccentChanged(option),
                  child: Container(
                    width: _swatch,
                    height: _swatch,
                    decoration: BoxDecoration(
                      color: option.primarySeed(brightness),
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                      border: Border.all(
                        color: option == accent
                            ? palette.onSurface
                            : Colors.transparent,
                        width: AppSizes.checkBorder,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ],
        ),
      ],
    );
  }
}
