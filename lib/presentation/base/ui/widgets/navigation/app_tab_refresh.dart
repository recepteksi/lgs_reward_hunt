import 'package:flutter/widgets.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_tab_scope.dart';

/// Calls [onShown] each time [tab] comes back on screen.
///
/// A kept-alive tab would otherwise show what it loaded when the app opened:
/// points earned on the map would not reach the shop. It comes back two ways —
/// another tab gives way to it, or the whole shell returns from under a page
/// pushed over it (the parent's gate and dashboard, where a child may have been
/// switched or a request decided) while it is the current tab. Both arrive
/// through `AppTabScope`. The first showing is not a return — the page loads
/// itself then. Outside the tab shell nothing ever calls [onShown]. [onShown]
/// gets this widget's context, which sits below the page's `BlocProvider`, so
/// it can reach the page's Cubit.
class AppTabRefresh extends StatefulWidget {
  const AppTabRefresh({
    required this.tab,
    required this.onShown,
    required this.child,
    super.key,
  });

  final AppNavTabEnum tab;

  final void Function(BuildContext context) onShown;

  final Widget child;

  @override
  State<AppTabRefresh> createState() => _AppTabRefreshState();
}

class _AppTabRefreshState extends State<AppTabRefresh> {
  AppNavTabEnum? _lastTab;

  int? _lastReturns;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AppTabScope? scope = AppTabScope.of(context);
    final AppNavTabEnum? current = scope?.currentTab;
    final bool switchedHere =
        _lastTab != null && _lastTab != widget.tab && current == widget.tab;
    final bool returnedHere =
        _lastReturns != null &&
        scope != null &&
        scope.returns != _lastReturns &&
        current == widget.tab;
    if (switchedHere || returnedHere) widget.onShown(context);
    _lastTab = current;
    _lastReturns = scope?.returns;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
