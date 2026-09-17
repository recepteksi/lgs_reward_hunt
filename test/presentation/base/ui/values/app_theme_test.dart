import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_fonts.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';

/// The contrast ratio between two opaque colours, by the WCAG definition.
///
/// Written out rather than taken from a package because it is nine lines and
/// because the number it produces is the reason several colours in this design
/// are what they are — white on the reward yellow is unreadable, which is why
/// the ink on it is a dark brown mixed from the yellow itself.
double _contrastRatio(Color foreground, Color background) {
  final double first = _relativeLuminance(foreground);
  final double second = _relativeLuminance(background);

  return first > second
      ? (first + 0.05) / (second + 0.05)
      : (second + 0.05) / (first + 0.05);
}

double _relativeLuminance(Color color) {
  double channel(double value) => value <= 0.03928
      ? value / 12.92
      : math.pow((value + 0.055) / 1.055, 2.4).toDouble();

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

/// The two pairs below are the design's own values and both sit under the 4.5
/// WCAG asks for small text: a button label measures 4.13 on the red accent,
/// and the muted meta line measures between 3.13 and 4.46 depending on accent
/// and ground. They are asserted at the floor they stand at today rather than
/// at the standard, so that the numbers cannot quietly get worse while the
/// design decides what to do about them — and so that raising them is a test
/// that has to be edited on purpose.
void main() {
  group('AppTheme', () {
    test('wears the accent the student picked, in both brightnesses', () {
      for (final AppAccentEnum accent in AppAccentEnum.values) {
        expect(
          AppTheme.light(accent).colorScheme.primary,
          accent.lightPrimary,
          reason: 'light ${accent.name}',
        );
        expect(
          AppTheme.dark(accent).colorScheme.primary,
          accent.darkPrimary,
          reason: 'dark ${accent.name}',
        );
      }
    });

    test('carries its palette, so a widget never has to name a colour', () {
      for (final AppAccentEnum accent in AppAccentEnum.values) {
        expect(AppTheme.light(accent).extension<AppPalette>(), isNotNull);
        expect(AppTheme.dark(accent).extension<AppPalette>(), isNotNull);
      }
    });

    test('keeps every accent readable, not just the default one', () {
      for (final AppAccentEnum accent in AppAccentEnum.values) {
        for (final Brightness brightness in Brightness.values) {
          final AppPalette palette = AppPalette.forAccent(accent, brightness);
          final String where = '${accent.name} ${brightness.name}';

          expect(
            _contrastRatio(palette.onReward, palette.reward),
            greaterThanOrEqualTo(4.5),
            reason: 'points on the reward fill · $where',
          );
          expect(
            _contrastRatio(palette.rewardInk, palette.rewardSoft),
            greaterThanOrEqualTo(4.5),
            reason: 'points on the soft reward pill · $where',
          );
          expect(
            _contrastRatio(palette.rewardInk, palette.rewardContainer),
            greaterThanOrEqualTo(4.5),
            reason: 'a pending badge · $where',
          );
          expect(
            _contrastRatio(
              palette.onPrimaryContainer,
              palette.primaryContainer,
            ),
            greaterThanOrEqualTo(4.5),
            reason: 'label on a tonal button · $where',
          );
          expect(
            _contrastRatio(palette.onSurface, palette.surface),
            greaterThanOrEqualTo(4.5),
            reason: 'body text on a card · $where',
          );
          expect(
            _contrastRatio(palette.onSurfaceVariant, palette.surface),
            greaterThanOrEqualTo(4.5),
            reason: 'a task title on a card · $where',
          );
          expect(
            _contrastRatio(palette.successInk, palette.successContainer),
            greaterThanOrEqualTo(4.5),
            reason: 'an approved reward · $where',
          );
          expect(
            _contrastRatio(palette.errorInk, palette.errorContainer),
            greaterThanOrEqualTo(4.5),
            reason: 'a failure card · $where',
          );
        }
      }
    });

    test('holds the line on the two pairs the design has not cleared yet', () {
      double worst(double Function(AppPalette) measure) {
        return AppAccentEnum.values
            .expand(
              (AppAccentEnum accent) => Brightness.values.map(
                (Brightness brightness) =>
                    measure(AppPalette.forAccent(accent, brightness)),
              ),
            )
            .reduce((double a, double b) => a < b ? a : b);
      }

      expect(
        worst((AppPalette p) => _contrastRatio(p.onPrimary, p.primary)),
        greaterThanOrEqualTo(4.12),
      );
      expect(
        worst((AppPalette p) => _contrastRatio(p.onSurfaceMuted, p.surface)),
        greaterThanOrEqualTo(3.96),
      );
      expect(
        worst(
          (AppPalette p) => _contrastRatio(p.onSurfaceMuted, p.surfaceHigh),
        ),
        greaterThanOrEqualTo(3.12),
      );
    });

    test('sets every text style in the one bundled face', () {
      final TextTheme text = AppTheme.light(AppAccentEnum.blue).textTheme;

      for (final TextStyle? style in <TextStyle?>[
        text.displayMedium,
        text.headlineSmall,
        text.titleMedium,
        text.titleSmall,
        text.labelLarge,
        text.bodyMedium,
        text.bodySmall,
        text.labelMedium,
        text.labelSmall,
        text.bodyLarge,
        text.titleLarge,
      ]) {
        expect(style?.fontFamily, AppFonts.family);
      }
    });

    test('gives the countdown figure the display size and weight', () {
      final TextStyle? display = AppTheme.light(AppAccentEnum.blue)
          .textTheme
          .displayMedium;

      expect(display?.fontSize, AppTypography.display);
      expect(display?.fontWeight, FontWeight.w900);
      expect(
        display?.fontFeatures,
        contains(const FontFeature.tabularFigures()),
      );
    });

    test('gives a button the full height a thumb needs', () {
      final Size? minimumSize = AppTheme.light(AppAccentEnum.blue)
          .filledButtonTheme
          .style
          ?.minimumSize
          ?.resolve(<WidgetState>{});

      expect(minimumSize?.height, AppSizes.buttonHeight);
    });
  });

  group('AppPalette', () {
    test(
      'interpolates by rebuilding, so a mid-animation theme is a real one',
      () {
        final AppPalette blue = AppPalette.forAccent(
          AppAccentEnum.blue,
          Brightness.light,
        );
        final AppPalette pink = AppPalette.forAccent(
          AppAccentEnum.pink,
          Brightness.light,
        );
        final AppPalette middle = blue.lerp(pink, 0.5);
        final Color expectedSeed = Color.lerp(
          blue.primarySeed,
          pink.primarySeed,
          0.5,
        )!;

        expect(middle.primary, expectedSeed);
        expect(
          middle.surface,
          AppPalette.forAccent(
            AppAccentEnum.blue,
            Brightness.light,
          ).lerp(pink, 0.5).surface,
        );
        expect(blue.lerp(blue, 0.5).primary, blue.primary);
      },
    );

    test('snaps rather than inventing a colour across a brightness change', () {
      final AppPalette light = AppPalette.forAccent(
        AppAccentEnum.blue,
        Brightness.light,
      );
      final AppPalette dark = AppPalette.forAccent(
        AppAccentEnum.blue,
        Brightness.dark,
      );

      expect(light.lerp(dark, 0.2).brightness, Brightness.light);
      expect(light.lerp(dark, 0.8).brightness, Brightness.dark);
    });
  });
}
