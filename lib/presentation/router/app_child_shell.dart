import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
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
/// which one is visible. The tab on screen is published through `AppTabScope`,
/// with a count of how often the shell has come back from under a page pushed
/// over it (its route's secondary animation settling back to dismissed); both
/// are how a tab knows to refresh.
class AppChildShell extends StatefulWidget {
  const AppChildShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  State<AppChildShell> createState() => _AppChildShellState();
}

class _AppChildShellState extends State<AppChildShell> {
  Animation<double>? _covering;

  int _returns = ValueConstants.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Animation<double>? covering = ModalRoute.of(context)
        ?.secondaryAnimation;
    if (covering == _covering) return;
    _covering?.removeStatusListener(_onCovering);
    _covering = covering?..addStatusListener(_onCovering);
  }

  void _onCovering(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      setState(() => _returns += ValueConstants.one);
    }
  }

  @override
  void dispose() {
    _covering?.removeStatusListener(_onCovering);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppNavTabEnum tab = AppNavTabEnum.values[widget.shell.currentIndex];

    return AppScaffold(
      bottomNavigationBar: AppChildNavigation(currentTab: tab),
      body: AppTabScope(
        currentTab: tab,
        returns: _returns,
        child: widget.shell,
      ),
    );
  }
}
