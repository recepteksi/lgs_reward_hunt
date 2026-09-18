import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns a [ThemeMode] into the word beside its switch.
///
/// Flutter's own enum rather than one of ours, because it is exactly the three
/// answers the app has — follow the device, or override it either way — and a
/// parallel enum would only have to be converted at the one place that matters.
String themeModeCopy(AppL10n l10n, ThemeMode mode) => switch (mode) {
  ThemeMode.system => l10n.themeModeSystem,
  ThemeMode.light => l10n.themeModeLight,
  ThemeMode.dark => l10n.themeModeDark,
};
