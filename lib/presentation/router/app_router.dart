import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_form/child_form_page.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_setup/child_setup_page.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/auth/auth_page.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/intro/intro_page.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/parent_gate/parent_gate_page.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/parent_pin/parent_pin_page.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/password/password_page.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/ui_kit_page.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/parent_page.dart';
import 'package:lgs_reward_hunt/presentation/profile/pages/profile/profile_page.dart';
import 'package:lgs_reward_hunt/presentation/progress/pages/progress/progress_page.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/reward_setup/reward_setup_page.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/rewards/rewards_page.dart';
import 'package:lgs_reward_hunt/presentation/router/app_child_shell.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:lgs_reward_hunt/presentation/router/app_tab_pager.dart';
import 'package:lgs_reward_hunt/presentation/router/arguments/password_arguments_model.dart';
import 'package:lgs_reward_hunt/presentation/session/pages/device_child/device_child_page.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/home_page.dart';
import 'package:lgs_reward_hunt/presentation/task/pages/task_setup/task_setup_page.dart';

/// The app's routing table.
///
/// One `GoRouter` for the whole app, built once by [of] and handed to
/// `MaterialApp.router`. Built here rather than inline in the widget because a
/// router rebuilt on every rebuild loses its history — the back gesture stops
/// working and nothing in the widget tree explains why. [of] takes the location
/// to open on, which `main` reads from the stored session, and caches the
/// router so a rebuild of the shell does not make a second one. [build] makes
/// a fresh one, uncached — what a test pumps, so every test starts clean.
///
/// The child tabs are the branches of one `StatefulShellRoute`, framed by
/// `AppChildShell`: the navigation bar stays put, and switching tabs changes
/// which kept-alive branch shows rather than going somewhere — so there is no
/// reload. `AppTabPager` lays the branches side by side, so a tab is also a
/// swipe away.
///
/// Each route registers under its `RoutePath.pathEnd` and is navigated to by
/// `RoutePath.path`, so neither is ever spelled as a literal here.
abstract final class AppRouter {
  static GoRouter of(String initialLocation) =>
      _instance ??= build(initialLocation);

  static GoRouter? _instance;

  static GoRouter build(String initialLocation) => GoRouter(
    initialLocation: initialLocation,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutePaths.intro.pathEnd(),
        builder: (_, _) => const IntroPage(),
      ),
      GoRoute(
        path: AppRoutePaths.auth.pathEnd(),
        builder: (_, _) => const AuthPage(),
      ),
      GoRoute(
        path: AppRoutePaths.password.pathEnd(),
        builder: (_, GoRouterState state) =>
            PasswordPage(arguments: state.extra! as PasswordArgumentsModel),
      ),
      GoRoute(
        path: AppRoutePaths.parentPin.pathEnd(),
        builder: (_, _) => const ParentPinPage(),
      ),
      GoRoute(
        path: AppRoutePaths.childSetup.pathEnd(),
        builder: (_, _) => const ChildSetupPage(),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.childForm.pathEnd(),
            builder: (_, _) => const ChildFormPage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutePaths.taskSetup.pathEnd(),
        builder: (_, _) => const TaskSetupPage(),
      ),
      GoRoute(
        path: AppRoutePaths.rewardSetup.pathEnd(),
        builder: (_, _) => const RewardSetupPage(),
      ),
      GoRoute(
        path: AppRoutePaths.deviceChild.pathEnd(),
        builder: (_, _) => const DeviceChildPage(),
      ),
      GoRoute(
        path: AppRoutePaths.parentGate.pathEnd(),
        builder: (_, _) => const ParentGatePage(),
      ),
      GoRoute(
        path: AppRoutePaths.parent.pathEnd(),
        builder: (_, _) => const ParentPage(),
      ),
      StatefulShellRoute(
        builder: (_, _, StatefulNavigationShell shell) =>
            AppChildShell(shell: shell),
        navigatorContainerBuilder: (
          _,
          StatefulNavigationShell shell,
          List<Widget> children,
        ) => AppTabPager(shell: shell, children: children),
        branches: <StatefulShellBranch>[
          for (final AppNavTabEnum tab in AppNavTabEnum.values)
            StatefulShellBranch(
              preload: true,
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutePaths.tab(tab).pathEnd(),
                  builder: (_, _) => switch (tab) {
                    AppNavTabEnum.home => const HomePage(),
                    AppNavTabEnum.rewards => const RewardsPage(),
                    AppNavTabEnum.progress => const ProgressPage(),
                    AppNavTabEnum.profile => const ProfilePage(),
                  },
                ),
              ],
            ),
        ],
      ),
      GoRoute(
        path: AppRoutePaths.uiKit.pathEnd(),
        builder: (_, _) => const UiKitPage(),
      ),
    ],
  );
}
