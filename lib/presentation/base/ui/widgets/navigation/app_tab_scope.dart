import 'package:flutter/widgets.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';

/// Which child tab is on screen, for the tabs kept alive beneath it.
///
/// The child tabs live in one shell that keeps all four built, so a tab that
/// is not showing still exists. [currentTab] is the one that is. [returns]
/// counts how many times the shell has come back into view after a page
/// pushed over all of it — the parent's gate and dashboard — was removed. A
/// tab reads both through [of] to know when it is shown again, and
/// `AppScaffold` reads [maybeTabOf] to know the navigation bar is already
/// drawn by the shell. Outside the shell both answer null.
class AppTabScope extends InheritedWidget {
  const AppTabScope({
    required this.currentTab,
    required this.returns,
    required super.child,
    super.key,
  });

  final AppNavTabEnum currentTab;

  final int returns;

  static AppTabScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppTabScope>();

  static AppNavTabEnum? maybeTabOf(BuildContext context) =>
      of(context)?.currentTab;

  @override
  bool updateShouldNotify(AppTabScope oldWidget) =>
      oldWidget.currentTab != currentTab || oldWidget.returns != returns;
}
