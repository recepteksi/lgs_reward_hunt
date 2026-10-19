import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_route.dart';

/// One feature's slice of the mock backend.
///
/// A handler owns the endpoints of one feature and the rules behind them —
/// accounts, tasks, the reward shop — and publishes them as [routes]. The
/// router only matches; it knows no rule.
abstract interface class MockHandlerInterface {
  List<MockRoute> get routes;
}
