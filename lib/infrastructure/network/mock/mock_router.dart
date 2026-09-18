import 'package:dio/dio.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/infrastructure/account/mock/mock_account_handler.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/mock/mock_auth_handler.dart';
import 'package:lgs_reward_hunt/infrastructure/avatar/mock/mock_avatar_handler.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_handler_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_request.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_response.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_route.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_store.dart';
import 'package:lgs_reward_hunt/infrastructure/points/mock/mock_points_handler.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/mock/mock_reward_handler.dart';
import 'package:lgs_reward_hunt/infrastructure/task/mock/mock_task_handler.dart';
import 'package:lgs_reward_hunt/infrastructure/task/mock/mock_task_plan_handler.dart';

/// The mock backend's route table: which handler answers which request.
///
/// It matches and nothing else. The data lives in `assets/mock/` and is loaded
/// into [MockStore] by `MockSeed`; the rules live in each feature's own
/// `infrastructure/<feature>/mock/` handler, which lists its endpoints at the top. That split is the point
/// of the mock: a fixture that replays the same JSON for every call cannot
/// express this product — completing a task has to move a balance, asking for
/// a reward has to hold the points, a rejection has to give them back — and
/// those are the SAME rules the server will enforce, so they are code.
///
/// An unmatched request answers 404 with a `messageKey`, the same contract a
/// real server uses, so a path spelled two ways fails loudly in a test.
///
/// `clock` is injected rather than read from `DateTime.now` so a test can put
/// the day before the exam under the assertion instead of waiting for it.
final class MockRouter {
  MockRouter(MockStore store, {required DateTime Function() clock})
    : _handlers = <MockHandlerInterface>[
        MockAvatarHandler(store),
        MockAuthHandler(store),
        MockAccountHandler(store),
        MockTaskHandler(store, clock),
        MockTaskPlanHandler(store, clock),
        MockRewardHandler(store, clock),
        MockPointsHandler(store),
      ];

  final List<MockHandlerInterface> _handlers;

  MockResponse handle(RequestOptions options) {
    final method = options.method.toUpperCase();

    for (final MockHandlerInterface handler in _handlers) {
      for (final MockRoute route in handler.routes) {
        if (route.method != method) continue;
        final match = route.pattern.firstMatch(options.path);
        if (match == null) continue;

        return route.handle(MockRequest.from(options, match));
      }
    }

    return MockResponse.fail(404, FailureMessageKey.unexpectedResponse);
  }
}
