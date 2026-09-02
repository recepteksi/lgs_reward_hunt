import 'package:flutter/material.dart';

/// The brand's seed colours, and nothing else.
///
/// Everything a widget paints with comes from `Theme.of(context).colorScheme`,
/// derived from these — so a widget never names a colour and dark mode is not a
/// second set of hard-coded values to keep in step. This file exists so the two
/// seeds are stated once.
abstract final class AppColors {
  /// The app's primary. A focused, encouraging blue: the product is a study
  /// companion, and red or orange on a countdown to an exam reads as alarm.
  static const Color seed = Color(0xFF2D6BE4);

  /// Reserved for the reward economy — coins, points and the shop — so value
  /// is instantly distinguishable from navigation.
  static const Color reward = Color(0xFFF2A03D);
}
