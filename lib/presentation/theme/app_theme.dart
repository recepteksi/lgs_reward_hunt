import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/theme/app_colors.dart';
import 'package:lgs_reward_hunt/presentation/theme/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/theme/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/theme/app_typography.dart';

/// The light and dark themes, built from one seed.
///
/// Both are generated from [AppColors.seed] rather than written out twice, so
/// dark mode cannot drift from light — the usual way that happens is a colour
/// added to one and forgotten in the other. A widget then reads
/// `Theme.of(context).colorScheme` and is correct in both by construction.
abstract final class AppTheme {
  /// The theme for a device in light mode.
  static ThemeData get light => _build(Brightness.light);

  /// The theme for a device in dark mode.
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      textTheme: _textTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSpacing.xxl + AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
      ),
    );
  }

  /// Sizes only — colour is applied by the [ColorScheme] above, so the same
  /// text theme serves both brightnesses.
  static const TextTheme _textTheme = TextTheme(
    displayMedium: TextStyle(
      fontSize: AppTypography.display,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      fontSize: AppTypography.headline,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      fontSize: AppTypography.title,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: TextStyle(fontSize: AppTypography.body),
    labelLarge: TextStyle(
      fontSize: AppTypography.label,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(fontSize: AppTypography.caption),
  );
}
