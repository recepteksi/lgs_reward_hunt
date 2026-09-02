import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/presentation/router/route_paths.dart';
import 'package:lgs_reward_hunt/presentation/screens/home/home_screen.dart';

/// The app's routing table.
///
/// One `GoRouter` for the whole app, built once and handed to `MaterialApp
/// .router`. Built here rather than inline in the widget because a router
/// rebuilt on every rebuild loses its history — the back gesture stops working
/// and nothing in the widget tree explains why.
abstract final class AppRouter {
  /// The single instance the app runs on.
  static final GoRouter instance = GoRouter(
    initialLocation: RoutePaths.home,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.home,
        name: AppRoute.home,
        builder: (_, _) => const HomeScreen(),
      ),
    ],
  );
}
