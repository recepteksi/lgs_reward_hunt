import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/settings/enums/theme_choice_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_fonts.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';

/// The themes, one pair per accent.
///
/// [light] and [dark] take the accent rather than reading it, because the
/// accent is a setting a student changes and a theme that fetched its own
/// colour would be a second place the choice lives. Everything either of them
/// paints comes from the [AppPalette] built for that accent — the `ColorScheme`
/// below is that palette translated into the roles Material's own widgets
/// understand, and the palette itself rides along as an extension for the many
/// roles Material has no word for.
///
/// The component themes exist so a page never restates a design decision. A
/// button is 48 high and 16 round wherever it appears; a card has a hairline
/// and no shadow; the navigation bar has no pill behind the selected tab. When
/// a page needs a control the theme does not describe, the fix is a component
/// theme or a widget in `presentation/base/`, not a `style:` argument — an
/// argument is a decision made where nobody looking for it will find it.
///
/// The one thing not themed here is the pressable face of a primary button:
/// its hard bottom edge and the four pixels it travels when pressed are motion,
/// not colour, and belong to `AppButton`.
///
/// Page transitions are fixed here rather than left to the framework's
/// default, which has changed between releases: a forward fade on Android and
/// the native slide on iOS. The child tabs switch without one — see the
/// router.
///
/// [modeFrom] and [choiceFrom] translate between the stored brightness choice
/// and Flutter's `ThemeMode`, in both directions.
abstract final class AppTheme {
  static ThemeMode modeFrom(ThemeChoiceEnum choice) => switch (choice) {
    ThemeChoiceEnum.system => ThemeMode.system,
    ThemeChoiceEnum.light => ThemeMode.light,
    ThemeChoiceEnum.dark => ThemeMode.dark,
  };

  static ThemeChoiceEnum choiceFrom(ThemeMode mode) => switch (mode) {
    ThemeMode.system => ThemeChoiceEnum.system,
    ThemeMode.light => ThemeChoiceEnum.light,
    ThemeMode.dark => ThemeChoiceEnum.dark,
  };

  static ThemeData light(AppAccentEnum accent) =>
      _build(accent, Brightness.light);

  static ThemeData dark(AppAccentEnum accent) =>
      _build(accent, Brightness.dark);

  static ThemeData _build(AppAccentEnum accent, Brightness brightness) {
    final AppPalette palette = AppPalette.forAccent(accent, brightness);
    final ColorScheme scheme = _scheme(palette, brightness);
    final TextTheme textTheme = _textTheme(palette);

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      textTheme: textTheme,
      fontFamily: AppFonts.family,
      scaffoldBackgroundColor: palette.background,
      splashFactory: InkSparkle.splashFactory,
      extensions: <ThemeExtension<dynamic>>[palette],
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: ValueConstants.zeroDouble,
        scrolledUnderElevation: ValueConstants.zeroDouble,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium,
        iconTheme: IconThemeData(
          size: AppSizes.iconSizeLarge,
          color: palette.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: ValueConstants.zeroDouble,
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: palette.outline, width: AppSizes.border),
          borderRadius: BorderRadius.circular(AppRadii.xxl),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primaryContainer,
          foregroundColor: palette.onPrimaryContainer,
          disabledBackgroundColor: palette.outline,
          disabledForegroundColor: palette.onSurfaceMuted,
          minimumSize: const Size(0, AppSizes.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primary,
          minimumSize: const Size(0, AppSizes.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          side: BorderSide(
            color: palette.outlineStrong,
            width: AppSizes.borderThick,
          ),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          minimumSize: const Size(0, AppSizes.minTapTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.sm),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: palette.outline,
        thickness: AppSizes.border,
        space: AppSizes.border,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
        circularTrackColor: palette.surfaceHigh,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: palette.outlineStrong,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.xxxl),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: ValueConstants.zeroDouble,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.xxl),
        ),
      ),
      splashColor: palette.onPrimaryDim,
      highlightColor: Colors.transparent,
    );
  }

  static ColorScheme _scheme(AppPalette palette, Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      primaryContainer: palette.primaryContainer,
      onPrimaryContainer: palette.onPrimaryContainer,
      secondary: palette.reward,
      onSecondary: palette.onReward,
      secondaryContainer: palette.rewardContainer,
      onSecondaryContainer: palette.rewardInk,
      tertiary: palette.success,
      onTertiary: palette.onPrimary,
      tertiaryContainer: palette.successContainer,
      onTertiaryContainer: palette.successInk,
      error: palette.error,
      onError: palette.onPrimary,
      errorContainer: palette.errorContainer,
      onErrorContainer: palette.errorInk,
      surface: palette.surface,
      onSurface: palette.onSurface,
      onSurfaceVariant: palette.onSurfaceVariant,
      surfaceContainerLowest: palette.surface,
      surfaceContainerLow: palette.background,
      surfaceContainer: palette.surfaceHigh,
      surfaceContainerHigh: palette.surfaceHigh,
      surfaceContainerHighest: palette.surfaceHigh,
      outline: palette.outlineStrong,
      outlineVariant: palette.outline,
      scrim: palette.scrim,
      shadow: palette.softShadow,
      inverseSurface: palette.onSurface,
      onInverseSurface: palette.surface,
      inversePrimary: palette.primaryContainer,
    );
  }

  static TextTheme _textTheme(AppPalette palette) {
    return TextTheme(
      displayMedium: TextStyle(
        fontSize: AppTypography.display,
        fontWeight: FontWeight.w900,
        height: _displayHeight,
        color: palette.onSurface,
        fontFeatures: <FontFeature>[const FontFeature.tabularFigures()],
      ),
      headlineSmall: TextStyle(
        fontSize: AppTypography.heading,
        fontWeight: FontWeight.w900,
        height: _headingHeight,
        color: palette.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: AppTypography.title,
        fontWeight: FontWeight.w900,
        height: _titleHeight,
        color: palette.onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: AppTypography.badge,
        fontWeight: FontWeight.w900,
        height: _tightHeight,
        color: palette.onSurface,
        fontFeatures: <FontFeature>[const FontFeature.tabularFigures()],
      ),
      labelLarge: const TextStyle(
        fontSize: AppTypography.button,
        fontWeight: FontWeight.w900,
        height: _tightHeight,
      ),
      bodyMedium: TextStyle(
        fontSize: AppTypography.body,
        fontWeight: FontWeight.w800,
        height: _bodyHeight,
        color: palette.onSurfaceVariant,
      ),
      bodySmall: TextStyle(
        fontSize: AppTypography.meta,
        fontWeight: FontWeight.w700,
        height: _metaHeight,
        color: palette.onSurfaceMuted,
      ),
      labelMedium: TextStyle(
        fontSize: AppTypography.caption,
        fontWeight: FontWeight.w700,
        height: _metaHeight,
        color: palette.onSurfaceMuted,
      ),
      labelSmall: TextStyle(
        fontSize: AppTypography.label,
        fontWeight: FontWeight.w800,
        height: _tightHeight,
        letterSpacing: AppTypography.labelTracking,
        color: palette.onSurfaceMuted,
      ),
    );
  }

  static const double _displayHeight = 1;

  static const double _headingHeight = 1.2;

  static const double _titleHeight = 1.3;

  static const double _tightHeight = 1;

  static const double _bodyHeight = 1.4;

  static const double _metaHeight = 1.35;
}
