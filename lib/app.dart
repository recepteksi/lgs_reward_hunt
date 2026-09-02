import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/flavors.dart';
import 'package:lgs_reward_hunt/infrastructure/config/app_config.dart';
import 'package:lgs_reward_hunt/presentation/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/router/app_router.dart';
import 'package:lgs_reward_hunt/presentation/theme/app_theme.dart';

/// The application shell: theme, localization and routing, and nothing else.
///
/// Deliberately thin. Anything with a rule in it belongs to a layer below —
/// what lives here is the wiring Flutter itself needs.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // The flavor's name, so a dev build is identifiable in the task switcher
      // rather than looking exactly like production.
      title: F.title,
      // Only ever on in dev: the banner is useful while building and is the
      // kind of thing that ships if it is left to a compile-time constant
      // nobody re-reads.
      debugShowCheckedModeBanner: AppConfig.isDevelopment,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // The device decides. An in-app override belongs in settings, and until
      // there is one, honouring the system is the only answer that is never
      // wrong.
      themeMode: ThemeMode.system,
      // Carries the flutter_localizations delegates as well as the generated
      // one, so Material's own strings are translated too.
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      routerConfig: AppRouter.instance,
    );
  }
}
