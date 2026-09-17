import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/core/constants/duration_constants.dart';
import 'package:lgs_reward_hunt/presentation/router/app_keep_alive_page.dart';

/// The child tabs side by side, swiped between as well as tapped.
///
/// The branch navigators of the tab shell ([children], in `AppNavTabEnum`
/// order) sit in a horizontal `PageView`, each kept alive. The two ways of
/// changing tab stay in step: a swipe that settles on a page calls
/// `goBranch`, so the bar and the address follow; a tap on the bar changes
/// [shell]'s index, and the pager animates to it. A horizontal list inside a
/// tab — the reward categories — still scrolls itself; the pager takes the
/// gesture everywhere else.
class AppTabPager extends StatefulWidget {
  const AppTabPager({required this.shell, required this.children, super.key});

  final StatefulNavigationShell shell;

  final List<Widget> children;

  @override
  State<AppTabPager> createState() => _AppTabPagerState();
}

class _AppTabPagerState extends State<AppTabPager> {
  late final PageController _controller = PageController(
    initialPage: widget.shell.currentIndex,
  );

  @override
  void didUpdateWidget(AppTabPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    final int index = widget.shell.currentIndex;
    if (_controller.hasClients && _controller.page?.round() != index) {
      _controller.animateToPage(
        index,
        duration: DurationConstants.pageTurn,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      onPageChanged: (int index) {
        if (index != widget.shell.currentIndex) widget.shell.goBranch(index);
      },
      children: <Widget>[
        for (final Widget child in widget.children)
          AppKeepAlivePage(child: child),
      ],
    );
  }
}
