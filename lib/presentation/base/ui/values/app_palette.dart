import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';

/// Every colour the app paints with, derived from one accent's three seeds.
///
/// This is the only file in the project that names a colour. Nothing else may:
/// the accent is a setting a student changes on the profile screen, so a hex
/// written into a widget is a widget that stays blue when the app turns pink.
/// `AppTheme` puts one of these on every `ThemeData`, and [of] is how a widget
/// reads it.
///
/// The derivation is the design system's own, ported rather than reinterpreted.
/// Two things about it are worth knowing. First, the neutrals are not grey:
/// every surface, outline and ink is mixed a few percent towards the accent's
/// tone, which is what makes five themes out of five colours instead of one
/// theme with a coloured button. Second, `Material`'s `ColorScheme` has no word
/// for most of what this app draws — the currency amber, the earned green, the
/// map's locked path, the hard bottom edge under a button — so those live here
/// rather than being approximated by a role that means something else.
///
/// [primaryEdge] and [rewardEdge] are that hard edge: buttons and map stops in
/// this design sit on a solid, unblurred offset rather than a shadow, which is
/// what gives them the pressable, slightly toy-like weight the product wants
/// and a blur cannot produce.
///
/// [avatarInk], [avatarHighlight] and [avatarBlush] are the eyes, the glint in
/// them and the cheeks of every avatar face. They are fixed rather than derived:
/// a face is drawn in its own colours, from the catalogue, and a child's eyes
/// do not turn pink with the accent.
///
/// [lerp] rebuilds from interpolated seeds instead of interpolating forty
/// fields, which is exact rather than approximate: every token is an affine mix
/// of the three seeds, so a mix of the outputs and the output of a mix are the
/// same colour. Across a brightness change there is no such identity — the two
/// formulas differ — so it snaps at the midpoint instead of inventing a colour
/// that belongs to neither theme.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette._({
    required this.accent,
    required this.brightness,
    required this.primarySeed,
    required this.rewardSeed,
    required this.toneSeed,
    required this.primary,
    required this.primaryShade,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.onPrimary,
    required this.onPrimarySoft,
    required this.onPrimaryDim,
    required this.reward,
    required this.rewardContainer,
    required this.rewardSoft,
    required this.onReward,
    required this.rewardInk,
    required this.success,
    required this.successContainer,
    required this.successInk,
    required this.error,
    required this.errorContainer,
    required this.errorInk,
    required this.background,
    required this.surface,
    required this.surfaceHigh,
    required this.outline,
    required this.outlineStrong,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.onSurfaceMuted,
    required this.navigationBar,
    required this.mapBase,
    required this.mapDot,
    required this.mapLine,
    required this.mapGlow,
    required this.mapRewardGlow,
    required this.mapGrid,
    required this.mapLocked,
    required this.mapLockedEdge,
    required this.mapLockedInk,
    required this.mapEdge,
    required this.mapRing,
    required this.scrim,
    required this.primaryEdge,
    required this.rewardEdge,
    required this.rewardSoftEdge,
    required this.primaryShadow,
    required this.rewardShadow,
    required this.softShadow,
  });

  factory AppPalette.forAccent(AppAccentEnum accent, Brightness brightness) {
    return AppPalette._seeded(
      accent: accent,
      brightness: brightness,
      primarySeed: accent.primarySeed(brightness),
      rewardSeed: accent.rewardSeed(brightness),
      toneSeed: accent.tone,
    );
  }

  factory AppPalette._seeded({
    required AppAccentEnum accent,
    required Brightness brightness,
    required Color primarySeed,
    required Color rewardSeed,
    required Color toneSeed,
  }) {
    final Color p = primarySeed;
    final Color s = rewardSeed;
    final Color t = toneSeed;

    if (brightness == Brightness.light) {
      final Color onSurface = _mix(_ink, t, 0.09);

      return AppPalette._(
        accent: accent,
        brightness: brightness,
        primarySeed: p,
        rewardSeed: s,
        toneSeed: t,
        primary: p,
        primaryShade: _mix(p, _ink, 0.16),
        primaryContainer: _mix(p, _white, 0.86),
        onPrimaryContainer: _mix(p, _ink, 0.55),
        onPrimary: _white,
        onPrimarySoft: _fade(_white, 0.82),
        onPrimaryDim: _fade(_white, 0.14),
        reward: s,
        rewardContainer: _mix(s, _white, 0.76),
        rewardSoft: _mix(s, _white, 0.87),
        onReward: _mix(s, _ink, 0.78),
        rewardInk: _mix(s, _ink, 0.56),
        success: _mix(const Color(0xFF46A97C), p, 0.12),
        successContainer: _mix(const Color(0xFFDEF3E9), p, 0.10),
        successInk: _mix(const Color(0xFF276A4C), p, 0.12),
        error: _mix(const Color(0xFFCE5A52), p, 0.08),
        errorContainer: _mix(const Color(0xFFFCE4E2), p, 0.08),
        errorInk: _mix(const Color(0xFF9E3A34), p, 0.10),
        background: _mix(const Color(0xFFF6F8FD), t, 0.09),
        surface: _mix(_white, t, 0.035),
        surfaceHigh: _mix(const Color(0xFFE9EDF7), t, 0.13),
        outline: _mix(const Color(0xFFE0E5F1), t, 0.15),
        outlineStrong: _mix(const Color(0xFFBFC6D6), t, 0.18),
        onSurface: onSurface,
        onSurfaceVariant: _mix(const Color(0xFF434857), t, 0.12),
        onSurfaceMuted: _mix(const Color(0xFF757A8A), t, 0.14),
        navigationBar: _fade(_mix(_white, t, 0.05), 0.90),
        mapBase: _mix(const Color(0xFFEEF3FA), t, 0.13),
        mapDot: _fade(t, 0.18),
        mapLine: _mix(const Color(0xFFD8E0EC), t, 0.20),
        mapGlow: _fade(t, 0.13),
        mapRewardGlow: _fade(s, 0.13),
        mapGrid: _fade(t, 0.07),
        mapLocked: _mix(const Color(0xFFE5EAF3), t, 0.13),
        mapLockedEdge: _mix(const Color(0xFFCFD6E3), t, 0.16),
        mapLockedInk: _mix(_mix(const Color(0xFF575E70), t, 0.18), _ink, 0.30),
        mapEdge: _mix(const Color(0xFFDDE4EF), t, 0.16),
        mapRing: _mix(const Color(0xFFEEF3FA), t, 0.13),
        scrim: _fade(_mix(_ink, t, 0.28), 0.54),
        primaryEdge: _mix(p, _ink, 0.34),
        rewardEdge: _mix(s, _ink, 0.34),
        rewardSoftEdge: _mix(_mix(s, _white, 0.87), _ink, 0.26),
        primaryShadow: _fade(p, 0.30),
        rewardShadow: _fade(s, 0.52),
        softShadow: _fade(_mix(onSurface, p, 0.3), 0.14),
      );
    }

    return AppPalette._(
      accent: accent,
      brightness: brightness,
      primarySeed: p,
      rewardSeed: s,
      toneSeed: t,
      primary: p,
      primaryShade: _mix(p, _white, 0.14),
      primaryContainer: _mix(t, const Color(0xFF0C0F16), 0.60),
      onPrimaryContainer: _mix(p, _white, 0.20),
      onPrimary: _mix(const Color(0xFF0B0E16), t, 0.10),
      onPrimarySoft: _fade(const Color(0xFF0B0E16), 0.66),
      onPrimaryDim: _fade(_white, 0.11),
      reward: s,
      rewardContainer: _mix(s, const Color(0xFF14100A), 0.74),
      rewardSoft: _mix(s, const Color(0xFF14100A), 0.82),
      onReward: _mix(s, _ink, 0.82),
      rewardInk: _mix(s, _white, 0.18),
      success: const Color(0xFF6FE0AE),
      successContainer: _mix(const Color(0xFF123D2C), t, 0.12),
      successInk: const Color(0xFFA7E7C6),
      error: const Color(0xFFFF9C93),
      errorContainer: _mix(const Color(0xFF48211E), t, 0.10),
      errorInk: const Color(0xFFFFB3AD),
      background: _mix(const Color(0xFF0C0F16), t, 0.17),
      surface: _mix(const Color(0xFF141924), t, 0.19),
      surfaceHigh: _mix(const Color(0xFF1E2430), t, 0.22),
      outline: _mix(const Color(0xFF2B3240), t, 0.22),
      outlineStrong: _mix(const Color(0xFF454D5E), t, 0.22),
      onSurface: _mix(const Color(0xFFEAECF5), t, 0.05),
      onSurfaceVariant: _mix(const Color(0xFFC6CBDA), t, 0.10),
      onSurfaceMuted: _mix(const Color(0xFF8F96A8), t, 0.18),
      navigationBar: _fade(_mix(const Color(0xFF141924), t, 0.19), 0.92),
      mapBase: _mix(const Color(0xFF101520), t, 0.20),
      mapDot: _fade(p, 0.20),
      mapLine: _mix(const Color(0xFF28303E), t, 0.24),
      mapGlow: _fade(t, 0.28),
      mapRewardGlow: _fade(s, 0.10),
      mapGrid: _fade(p, 0.05),
      mapLocked: _mix(const Color(0xFF1A2029), t, 0.20),
      mapLockedEdge: _mix(const Color(0xFF2A323E), t, 0.22),
      mapLockedInk: _mix(_mix(const Color(0xFFA8B0C0), p, 0.16), _white, 0.16),
      mapEdge: _mix(const Color(0xFF242B38), t, 0.22),
      mapRing: _mix(const Color(0xFF101520), t, 0.20),
      scrim: const Color(0xA804060C),
      primaryEdge: _mix(p, _ink, 0.42),
      rewardEdge: _mix(s, _ink, 0.34),
      rewardSoftEdge: _mix(_mix(s, const Color(0xFF14100A), 0.82), _ink, 0.26),
      primaryShadow: _fade(p, 0.42),
      rewardShadow: _fade(s, 0.26),
      softShadow: const Color(0x73000000),
    );
  }

  static const Color avatarInk = Color(0xFF2C2740);

  static const Color avatarHighlight = Color(0xFFFFFFFF);

  static const Color avatarBlush = Color(0xFFF0839F);

  static const Color _white = Color(0xFFFFFFFF);

  static const Color _ink = Color(0xFF181B24);

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>()!;

  static Color _mix(Color from, Color to, double amount) =>
      Color.lerp(from, to, amount)!;

  static Color _fade(Color color, double opacity) =>
      color.withValues(alpha: opacity);

  final AppAccentEnum accent;

  final Brightness brightness;

  final Color primarySeed;

  final Color rewardSeed;

  final Color toneSeed;

  final Color primary;

  final Color primaryShade;

  final Color primaryContainer;

  final Color onPrimaryContainer;

  final Color onPrimary;

  final Color onPrimarySoft;

  final Color onPrimaryDim;

  final Color reward;

  final Color rewardContainer;

  final Color rewardSoft;

  final Color onReward;

  final Color rewardInk;

  final Color success;

  final Color successContainer;

  final Color successInk;

  final Color error;

  final Color errorContainer;

  final Color errorInk;

  final Color background;

  final Color surface;

  final Color surfaceHigh;

  final Color outline;

  final Color outlineStrong;

  final Color onSurface;

  final Color onSurfaceVariant;

  final Color onSurfaceMuted;

  final Color navigationBar;

  final Color mapBase;

  final Color mapDot;

  final Color mapLine;

  final Color mapGlow;

  final Color mapRewardGlow;

  final Color mapGrid;

  final Color mapLocked;

  final Color mapLockedEdge;

  final Color mapLockedInk;

  final Color mapEdge;

  final Color mapRing;

  final Color scrim;

  final Color primaryEdge;

  final Color rewardEdge;

  final Color rewardSoftEdge;

  final Color primaryShadow;

  final Color rewardShadow;

  final Color softShadow;

  @override
  AppPalette copyWith({AppAccentEnum? accent, Brightness? brightness}) =>
      AppPalette.forAccent(
        accent ?? this.accent,
        brightness ?? this.brightness,
      );

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }

    if (other.brightness != brightness) {
      return t < 0.5 ? this : other;
    }

    return AppPalette._seeded(
      accent: t < 0.5 ? accent : other.accent,
      brightness: brightness,
      primarySeed: _mix(primarySeed, other.primarySeed, t),
      rewardSeed: _mix(rewardSeed, other.rewardSeed, t),
      toneSeed: _mix(toneSeed, other.toneSeed, t),
    );
  }
}
