import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_handler_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_request.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_response.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_route.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_store.dart';

/// A child's points, as the ledger that produced them.
///
/// There is no stored balance to answer with: the account is the child's
/// ledger entries, and the app sums them. The entries themselves are written
/// by the task and reward handlers, which is where points actually move.
final class MockPointsHandler implements MockHandlerInterface {
  const MockPointsHandler(this._store);

  final MockStore _store;

  @override
  List<MockRoute> get routes => <MockRoute>[
    MockRoute('GET', RegExp(r'^/children/([^/]+)/points$'), _accountOf),
  ];

  MockResponse _accountOf(MockRequest request) =>
      MockResponse.ok(<String, Object?>{
        'childId': request.id,
        'entries': _store.ledger
            .where((Map<String, Object?> e) => e['childId'] == request.id)
            .toList(),
      });
}
