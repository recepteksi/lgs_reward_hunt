import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/settings/cubit/appearance/appearance_cubit.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_theme.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/debug/widgets/debug_accounts_overlay.dart';
import 'package:lgs_reward_hunt/presentation/router/app_router.dart';

/// The application shell: theme, localization and routing, and nothing else.
///
/// Deliberately thin. Anything with a rule in it belongs to a layer below —
/// what lives here is the wiring Flutter itself needs.
///
/// What differs between flavors arrives as arguments rather than being read
/// from `AppConfig`: `presentation` may not import `infrastructure`, and `main`
/// is the composition root that is allowed to see both. [title] is the name the
/// OS shows for this build. [showDebugBanner] is only ever true in dev — the
/// banner is useful while building and is the kind of thing that ships if it is
/// left to a compile-time constant nobody re-reads.
///
/// The accent and the brightness come from [AppearanceCubit], which sits ABOVE
/// `MaterialApp` because it is read by every screen and changed from one of
/// them. It is the only Cubit in the app not owned by a screen, and it is
/// restored by `main` before the first frame, so the app never shows the
/// default blue for an instant and then snaps to the colour the student chose.
///
/// [startAt] is where the app opens, decided by `main` from the stored session:
/// the map for a signed-in device, the account step for a fresh one.
///
/// The locale is pinned to Turkish rather than following the device. The app is
/// for one exam in one country: a student whose phone is set to English is
/// still sitting the LGS, and showing them a half-translated interface would be
/// worse than showing them the language the copy was written in.
///
/// The localization delegates carry `flutter_localizations`' own as well as the
/// generated one, so Material's strings are translated too.
///
/// [debugAccounts] reads the backend's accounts for the see-through
/// [DebugAccountsOverlay] button; `main` hands it in for the dev flavor only,
/// and without it no button is built.
///
/// [appearance] is the app-wide appearance Cubit. `main` hands it in because
/// only the composition root and a page's `BlocProvider` may reach `getIt`.
class App extends StatelessWidget {
  const App({
    required this.title,
    required this.showDebugBanner,
    required this.startAt,
    required this.appearance,
    this.debugAccounts,
    super.key,
  });

  final String title;

  final bool showDebugBanner;

  final String startAt;

  final AppearanceCubit appearance;

  final List<Map<String, String>> Function()? debugAccounts;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppearanceCubit>.value(
      value: appearance,
      child: BlocBuilder<AppearanceCubit, AppearanceState>(
        builder: (BuildContext context, AppearanceState state) {
          final AppAccentEnum accent = AppAccentEnum.from(
            state.settings.accent,
          );

          return MaterialApp.router(
            title: title,
            debugShowCheckedModeBanner: showDebugBanner,
            theme: AppTheme.light(accent),
            darkTheme: AppTheme.dark(accent),
            themeMode: AppTheme.modeFrom(state.settings.theme),
            locale: AppL10n.supportedLocales.first,
            localizationsDelegates: AppL10n.localizationsDelegates,
            supportedLocales: AppL10n.supportedLocales,
            routerConfig: AppRouter.of(startAt),
            builder: _withDebugAccounts,
          );
        },
      ),
    );
  }

  Widget _withDebugAccounts(BuildContext context, Widget? child) {
    final List<Map<String, String>> Function()? read = debugAccounts;
    final Widget page = child ?? const SizedBox.shrink();
    return read == null
        ? page
        : DebugAccountsOverlay(readAccounts: read, child: page);
  }
}
