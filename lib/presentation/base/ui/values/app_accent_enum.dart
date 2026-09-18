import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/settings/enums/accent_choice_enum.dart';

/// The five colour ways a student can choose between.
///
/// A thirteen-year-old who cannot change anything about an app they were told
/// to install does not think of it as theirs, and the cheapest thing this
/// product can hand over is its colour. So the accent is a real setting on the
/// profile screen, not a constant — which is why nothing in the app may name a
/// colour: every surface in every screen is derived from whichever of these is
/// selected.
///
/// An accent is three seeds rather than a palette. [lightPrimary] and
/// [darkPrimary] are the brand colour of the choice — two values, because a
/// blue bright enough to sit on white disappears on near-black. [lightReward]
/// and [darkReward] are the currency colour beside it, kept a different hue
/// from the primary in every accent so that points never read as navigation.
/// [tone] is the saturated note every neutral is tinted with, and it is one
/// value for both brightnesses: it is what makes the blue theme's grey a
/// blue-grey rather than a grey, and it is the difference between five themes
/// and one theme with five buttons in it.
///
/// `AppPalette` turns the three into the forty-odd colours a screen actually
/// paints with, and [from] is where the stored choice becomes one of these —
/// the domain remembers WHICH colour was picked, this file is the only place
/// that knows what it looks like. [choice] is the way back, for saving one.
enum AppAccentEnum {
  blue(
    lightPrimary: Color(0xFF3D74D6),
    darkPrimary: Color(0xFF9FC0FF),
    lightReward: Color(0xFFF2D66B),
    darkReward: Color(0xFFF5D97A),
    tone: Color(0xFF2F62CC),
  ),
  pink(
    lightPrimary: Color(0xFFD14C86),
    darkPrimary: Color(0xFFFF9FC6),
    lightReward: Color(0xFF5FC49B),
    darkReward: Color(0xFF7FE2B8),
    tone: Color(0xFFCE3E7C),
  ),
  green(
    lightPrimary: Color(0xFF1E8C5F),
    darkPrimary: Color(0xFF6FE0AE),
    lightReward: Color(0xFFEFD277),
    darkReward: Color(0xFFF5D97A),
    tone: Color(0xFF0F9163),
  ),
  yellow(
    lightPrimary: Color(0xFF9A6511),
    darkPrimary: Color(0xFFFFCE5C),
    lightReward: Color(0xFF6FA8F0),
    darkReward: Color(0xFF9FC0FF),
    tone: Color(0xFFD08B0F),
  ),
  red(
    lightPrimary: Color(0xFFC4483F),
    darkPrimary: Color(0xFFFF9C93),
    lightReward: Color(0xFFEFD277),
    darkReward: Color(0xFFF5D97A),
    tone: Color(0xFFD2453A),
  );

  const AppAccentEnum({
    required this.lightPrimary,
    required this.darkPrimary,
    required this.lightReward,
    required this.darkReward,
    required this.tone,
  });

  static const AppAccentEnum fallback = AppAccentEnum.blue;

  static AppAccentEnum from(AccentChoiceEnum choice) => switch (choice) {
    AccentChoiceEnum.blue => AppAccentEnum.blue,
    AccentChoiceEnum.pink => AppAccentEnum.pink,
    AccentChoiceEnum.green => AppAccentEnum.green,
    AccentChoiceEnum.yellow => AppAccentEnum.yellow,
    AccentChoiceEnum.red => AppAccentEnum.red,
  };

  AccentChoiceEnum get choice => switch (this) {
    AppAccentEnum.blue => AccentChoiceEnum.blue,
    AppAccentEnum.pink => AccentChoiceEnum.pink,
    AppAccentEnum.green => AccentChoiceEnum.green,
    AppAccentEnum.yellow => AccentChoiceEnum.yellow,
    AppAccentEnum.red => AccentChoiceEnum.red,
  };

  final Color lightPrimary;

  final Color darkPrimary;

  final Color lightReward;

  final Color darkReward;

  final Color tone;

  Color primarySeed(Brightness brightness) =>
      brightness == Brightness.light ? lightPrimary : darkPrimary;

  Color rewardSeed(Brightness brightness) =>
      brightness == Brightness.light ? lightReward : darkReward;
}
