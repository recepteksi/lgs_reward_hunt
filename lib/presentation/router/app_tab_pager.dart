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
/// [shell]'s index, and the pager animates to it. While that animation runs,
/// the pages it passes are not tab changes — without the guard a tap from the
/// map to the profile would switch to rewards and progress on the way, and
/// reload both. Only the tab on screen keeps its tickers running (`TickerMode`):
/// a hidden tab's shimmer or animation does not spin in the background. A
/// horizontal list inside a tab — the reward categories — still scrolls
/// itself; the pager takes the gesture everywhere else.
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

  bool _animating = false;

  @override
  void didUpdateWidget(AppTabPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    final int index = widget.shell.currentIndex;
    if (!_controller.hasClients || _animating) return;
    if (_controller.page?.round() == index) return;

    _animating = true;
    _controller
        .animateToPage(
          index,
          duration: DurationConstants.pageTurn,
          curve: Curves.easeOut,
        )
        .whenComplete(() => _animating = false);
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
        if (_animating || index == widget.shell.currentIndex) return;
        widget.shell.goBranch(index);
      },
      children: <Widget>[
        for (int index = 0; index < widget.children.length; index++)
          AppKeepAlivePage(
            child: TickerMode(
              enabled: index == widget.shell.currentIndex,
              child: widget.children[index],
            ),
          ),
      ],
    );
  }
}
