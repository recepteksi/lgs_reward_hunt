import 'package:flutter/widgets.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';

/// Which child tab is on screen, for the tabs kept alive beneath it.
///
/// The child tabs live in one shell that keeps all four built, so a tab that
/// is not showing still exists. [currentTab] is the one that is; a tab reads
/// it through [maybeOf] to know when it comes back into view, and
/// `AppScaffold` reads it to know the navigation bar is already drawn by the
/// shell. Outside the shell [maybeOf] answers null.
class AppTabScope extends InheritedWidget {
  const AppTabScope({
    required this.currentTab,
    required super.child,
    super.key,
  });

  final AppNavTabEnum currentTab;

  static AppNavTabEnum? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppTabScope>()?.currentTab;

  @override
  bool updateShouldNotify(AppTabScope oldWidget) =>
      oldWidget.currentTab != currentTab;
}
