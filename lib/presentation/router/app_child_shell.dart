import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_child_navigation.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_tab_scope.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';

/// The frame the four child tabs share: one navigation bar that never leaves
/// the screen, and the tabs beneath it kept alive.
///
/// Each tab used to be its own route with its own bar, so switching rebuilt
/// the whole screen — bar included — and showed a bare loading page on the
/// way. Here [shell] is go_router's `StatefulNavigationShell`: its branches
/// are the tabs, in `AppNavTabEnum` order, built once and preloaded, so a
/// switch — a tap on the bar or a swipe across `AppTabPager` — only changes
/// which one is visible. The tab on screen is published
/// through `AppTabScope`, which is how a tab refreshes when it comes back.
class AppChildShell extends StatelessWidget {
  const AppChildShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final AppNavTabEnum tab = AppNavTabEnum.values[shell.currentIndex];

    return AppScaffold(
      bottomNavigationBar: AppChildNavigation(currentTab: tab),
      body: AppTabScope(currentTab: tab, child: shell),
    );
  }
}
