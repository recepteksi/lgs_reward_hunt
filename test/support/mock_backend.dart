import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/infrastructure/network/crypto/passthrough_payload_codec.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';

/// A Dio client with the mock backend installed, the way `main` installs it.
///
/// The mock reads its content from `assets/mock/`, which needs the Flutter
/// binding even in a plain `test`, so this makes sure one exists. [clock] is
/// the backend's "now"; [withDemoHousehold] adds the demo family on top of the
/// catalogue.
Future<DioClient> mockBackend({
  bool withDemoHousehold = true,
  DateTime Function()? clock,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final DioClient client = DioClient(const PassthroughPayloadCodec());
  if (clock != null) client.clock = clock;
  await client.initMock(withDemoHousehold: withDemoHousehold);
  return client;
}

/// The demo household's parent row, as `demo_household.json` seeded it.
Map<String, Object?> demoParent(DioClient client) =>
    client.mockStore.parents.first;
