import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_app_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/body/ui_kit_body.dart';

/// A temporary sheet showing every component in `base/ui/widgets/`.
///
/// It is scaffolding for building the product, not part of it: reachable from
/// the home app bar in a debug build only, linked from nowhere, and meant to be
/// deleted or reduced once the real pages exist. It is here because a
/// component nobody can open on a device is one nobody checks in dark mode or
/// on the yellow accent — the two places this design breaks first.
///
/// The screen owns the preview choices and re-themes its own subtree with them,
/// so five colour ways and three brightness settings can be checked without
/// touching anything the rest of the app reads. The body below it does the
/// laying out and is handed the choices.
///
/// It has no Cubit, and should not: nothing is fetched, nothing can fail, and
/// the state is which specimen is selected. Its copy is not localized either —
/// the words name components rather than speak to a user. Copy INSIDE a
/// component still comes from `AppL10n`, because that copy ships.
class UiKitPage extends StatefulWidget {
  const UiKitPage({super.key});

  @override
  State<UiKitPage> createState() => _UiKitPageState();
}

/// Which theme the sheet is being previewed in.
class _UiKitPageState extends State<UiKitPage> {
  ThemeMode _mode = ThemeMode.system;

  AppAccentEnum _accent = AppAccentEnum.fallback;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = switch (_mode) {
      ThemeMode.system => MediaQuery.platformBrightnessOf(context),
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
    };

    return Theme(
      data: brightness == Brightness.light
          ? AppTheme.light(_accent)
          : AppTheme.dark(_accent),
      child: Builder(
        builder: (BuildContext context) {
          return AppScaffold(
            appBar: const AppAppBar(title: 'UI Kit'),
            body: UiKitBody(
              mode: _mode,
              accent: _accent,
              onModeChanged: (ThemeMode mode) => setState(() => _mode = mode),
              onAccentChanged: (AppAccentEnum accent) =>
                  setState(() => _accent = accent),
            ),
          );
        },
      ),
    );
  }
}
