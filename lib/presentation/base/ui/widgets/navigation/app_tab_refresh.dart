import 'package:flutter/widgets.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_tab_scope.dart';

/// Calls [onShown] each time [tab] comes back on screen.
///
/// A kept-alive tab would otherwise show what it loaded when the app opened:
/// points earned on the map would not reach the shop. The first showing is
/// not a return — the page loads itself then — so only a change from another
/// tab to [tab] counts. Outside the tab shell nothing ever calls [onShown].
/// [onShown] gets this widget's context, which sits below the page's
/// `BlocProvider`, so it can reach the page's Cubit.
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
  AppNavTabEnum? _last;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AppNavTabEnum? current = AppTabScope.maybeOf(context);
    if (_last != null && _last != widget.tab && current == widget.tab) {
      widget.onShown(context);
    }
    _last = current;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
