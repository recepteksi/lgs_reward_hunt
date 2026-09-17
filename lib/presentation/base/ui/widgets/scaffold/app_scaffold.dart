import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_app_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_child_navigation.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_tab_scope.dart';

/// The frame every page sits in, with the app's bars in Material's slots.
///
/// Material's `Scaffold` does the laying out and this is not a replacement for
/// it — it is the place the answers every page gives identically are given
/// once. The background is the palette's, not the theme's default surface, so
/// a page that forgets is still the right colour when the accent changes. The
/// body is inside a `SafeArea` because a phone with a notch is every phone
/// now, and the bottom is excluded from it when there is a bar down there,
/// since the bar does its own inset.
///
/// A bar goes in its slot, never into the body. [appBar] is an `AppAppBar` and
/// [bottomNavigationBar] an `AppChildNavigation` — the kit's bar, wired to the tabs'
/// routes — the types say so, so a page cannot
/// pass Material's `AppBar` or draw a back arrow at the top of its own list.
/// In the slot, a bar stays put while the body scrolls, is sized and inset by
/// the scaffold, and is what the system reads as the page's navigation.
///
/// [extendBehindBottomBar] is on by default and matters more than it looks: the
/// parent button rides thirty pixels above the navigation bar, so a scaffold
/// that clipped its bottom bar would cut the top off the one control the parent
/// flow is reached through.
///
/// [extendBehindAppBar] runs the body under a floating `AppAppBar.overlay`,
/// for a full-bleed page like the map; the page then insets its own top.
///
/// [padding] is the page's own edge, and it defaults to none: a map that
/// bleeds to the edges and a settings list that does not are both normal, so
/// the page says which it is rather than fighting a default.
///
/// What is NOT here is a loading or error state — those are `AppLoadingView`
/// and `AppErrorView`, and a scaffold that also knew about them would be
/// deciding what a page shows as well as where it sits.
///
/// A page inside the child tab shell (`AppTabScope`) has no bar of its own —
/// the shell draws it — but still leaves the bottom inset to the bar, as a
/// page carrying one does.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.background,
    this.padding = EdgeInsets.zero,
    this.extendBehindBottomBar = true,
    this.extendBehindAppBar = false,
    super.key,
  });

  final Widget body;

  final AppAppBar? appBar;

  final AppChildNavigation? bottomNavigationBar;

  final Color? background;

  final EdgeInsetsGeometry padding;

  final bool extendBehindBottomBar;

  final bool extendBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background ?? AppPalette.of(context).background,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      extendBody: extendBehindBottomBar,
      extendBodyBehindAppBar: extendBehindAppBar,
      body: SafeArea(
        top: appBar == null && !extendBehindAppBar,
        bottom:
            bottomNavigationBar == null && AppTabScope.maybeOf(context) == null,
        child: Padding(padding: padding, child: body),
      ),
    );
  }
}
