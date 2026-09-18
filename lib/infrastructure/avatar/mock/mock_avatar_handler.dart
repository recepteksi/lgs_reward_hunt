import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_handler_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_response.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_route.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_store.dart';

/// The avatar catalogue, served as `MockSeed` loaded it.
///
/// No rules here — the catalogue is content, and a file of data describes it
/// fully.
final class MockAvatarHandler implements MockHandlerInterface {
  const MockAvatarHandler(this._store);

  final MockStore _store;

  @override
  List<MockRoute> get routes => <MockRoute>[
    MockRoute(
      'GET',
      RegExp(r'^/avatars$'),
      (_) => MockResponse.ok(_store.avatars),
    ),
  ];
}
