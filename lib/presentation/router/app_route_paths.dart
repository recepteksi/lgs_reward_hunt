import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/router/route_path.dart';

/// Every address in the app, written once.
///
/// A path typed at a call site is a string nothing checks: a typo compiles and
/// fails at the tap. Each route is a [RoutePath] built from the one above it,
/// so a nested screen never restates its parent's segments and renaming a
/// parent moves everything beneath it.
///
/// Setup is a straight line — [intro] · [auth] · [password] · [parentPin] and
/// then the child, task and reward steps — so each step is a route of its own
/// rather than an index in one screen: a parent who kills the app halfway comes
/// back to the step they were on, and the back gesture means what it looks like.
///
/// [childSetup] lists the household's children and [childForm], beneath it,
/// adds one — nested, so closing the form is a pop back onto the list.
///
/// [taskSetup] is the plan a child's days are written from, and
/// [rewardSetup] the pool the points are spent on. [deviceChild] ends setup:
/// which child this device opens on.
///
/// [rewards], [progress] and [profile] are the other child tabs.
/// [parentGate] is the PIN between them and [parent], the parent's side.
///
/// [tab] is where a navigation bar tab leads.
///
/// [home] is the map — where a student lands.
/// [uiKit] is the temporary kit sheet: every shared widget on one scroll. It is
/// registered like any other route but linked from nowhere in the product — the
/// home screen offers it only in a debug build.
abstract final class AppRoutePaths {
  static const RoutePath intro = RoutePath(pathEnd: 'intro');

  static const RoutePath auth = RoutePath(pathEnd: 'auth');

  static const RoutePath password = RoutePath(pathEnd: 'password');

  static const RoutePath parentPin = RoutePath(pathEnd: 'parent-pin');

  static const RoutePath childSetup = RoutePath(pathEnd: 'child-setup');

  static const RoutePath childForm = RoutePath(
    pathEnd: 'new',
    parent: childSetup,
  );

  static const RoutePath taskSetup = RoutePath(pathEnd: 'task-setup');

  static const RoutePath rewardSetup = RoutePath(pathEnd: 'reward-setup');

  static const RoutePath deviceChild = RoutePath(pathEnd: 'device-child');

  static const RoutePath rewards = RoutePath(pathEnd: 'rewards');

  static const RoutePath progress = RoutePath(pathEnd: 'progress');

  static const RoutePath profile = RoutePath(pathEnd: 'profile');

  static const RoutePath parentGate = RoutePath(pathEnd: 'parent-gate');

  static const RoutePath parent = RoutePath(pathEnd: 'parent');

  static const RoutePath home = RoutePath(pathEnd: 'home');

  static const RoutePath uiKit = RoutePath(pathEnd: 'ui-kit');

  static RoutePath tab(AppNavTabEnum tab) => switch (tab) {
    AppNavTabEnum.home => home,
    AppNavTabEnum.rewards => rewards,
    AppNavTabEnum.progress => progress,
    AppNavTabEnum.profile => profile,
  };
}
