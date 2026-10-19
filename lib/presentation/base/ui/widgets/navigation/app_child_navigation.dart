import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_bottom_nav.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';

/// The navigation bar every child tab carries, already wired to the routes.
///
/// `AppBottomNav` draws the bar and knows nothing about where a tab leads;
/// this is the one place that answer lives, so the map, the shop and the
/// progress tab cannot route a tab differently. Tapping the tab already
/// showing does nothing, and the parent button opens the PIN gate over the
/// tab. [currentTab] is the tab this bar is on.
class AppChildNavigation extends StatelessWidget {
  const AppChildNavigation({required this.currentTab, super.key});

  final AppNavTabEnum currentTab;

  @override
  Widget build(BuildContext context) {
    return AppBottomNav(
      currentTab: currentTab,
      onSelected: (AppNavTabEnum tab) {
        if (tab != currentTab) context.go(AppRoutePaths.tab(tab).path());
      },
      onParentPressed: () => context.push(AppRoutePaths.parentGate.path()),
    );
  }
}
