import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/infrastructure/network/crypto/passthrough_payload_codec.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The mock backend kept on the device, the way `main` starts it.
///
/// A parent who signs up and reopens the app must still exist. Before this,
/// the store was seeded again on every launch while the session survived, so
/// every page asked for an account that was gone.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  Future<DioClient> launch() async {
    final DioClient client = DioClient(const PassthroughPayloadCodec());
    await client.initMock(keepOnDevice: true);
    return client;
  }

  test(
    'a parent who signed up is still there after the app restarts',
    () async {
      final DioClient first = await launch();
      final response = await first.dio.post<Map<String, dynamic>>(
        '/auth/sign-up',
        data: <String, Object?>{
          'name': 'Yeni Veli',
          'email': 'yeni@ornek.com',
          'password': 'sifre1234',
        },
      );
      final String parentId = response.data!['id']! as String;

      final DioClient second = await launch();

      expect(
        second.mockStore.findById(second.mockStore.parents, parentId),
        isNotNull,
      );
      expect(second.mockStore.parents.length, first.mockStore.parents.length);
      expect(second.mockStore.tasks.length, first.mockStore.tasks.length);
      expect(
        second.mockStore.findById(
          second.mockStore.parents,
          second.mockStore.nextId('parent'),
        ),
        isNull,
      );
    },
  );

  test('a store that cannot be read is seeded again', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'mock.store': '{"broken": true}',
    });

    final DioClient client = await launch();

    expect(client.mockStore.parents, isNotEmpty);
    expect(client.mockStore.avatars, isNotEmpty);
  });
}
