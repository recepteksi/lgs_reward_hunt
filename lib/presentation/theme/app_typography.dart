import 'package:flutter/material.dart';

/// Type sizes, by role.
///
/// A size is chosen by what the text IS, not by how big it should look — that
/// is what keeps two screens agreeing about what a title is. Sizes only:
/// weight and colour come from the [TextTheme] the app builds from these.
abstract final class AppTypography {
  /// The countdown's number and nothing else — display type earns its size by
  /// being the one thing on the screen a student came to see.
  static const double display = 48;
  static const double headline = 28;
  static const double title = 20;
  static const double body = 15;
  static const double label = 13;
  static const double caption = 12;
}
