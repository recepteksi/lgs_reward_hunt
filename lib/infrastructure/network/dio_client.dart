import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/infrastructure/config/app_config.dart';
import 'package:lgs_reward_hunt/infrastructure/network/crypto/payload_codec_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/network/interceptors/crypto_interceptor.dart';
import 'package:lgs_reward_hunt/infrastructure/network/interceptors/error_interceptor.dart';
import 'package:lgs_reward_hunt/infrastructure/network/interceptors/session_interceptor.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_http_client_adapter.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_router.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_seed.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_store.dart';

/// The one Dio the app talks through.
///
/// A single client rather than one per repository: interceptors, the base URL
/// and the session header are decisions the whole app shares, and a second Dio
/// is a second place for them to be configured differently.
///
/// [initMock] is what runs today, because [AppConfig.apiBaseUrl] names a host
/// that does not exist yet. It replaces the transport — and nothing else —
/// with [MockHttpClientAdapter], so interceptors, encoding, status codes and
/// every repository's parsing run exactly as they will against the real
/// server. It loads the backend's content from `assets/mock/` and, unless
/// [initMock] is told otherwise, the demo household; `main` calls it while
/// `AppConfig.useMockBackend` is on. [disableMock] puts the real transport
/// back; the day a backend appears, turning that flag off is the whole
/// migration.
///
/// [currentAccountId] is what [SessionInterceptor] reads on every request. It
/// is a mutable field rather than a constructor argument because the account
/// changes while the app runs — a parent finishes setup and hands the phone to
/// their child.
///
/// [mockStore] is exposed so a test can look at what the backend actually did
/// rather than inferring it from three more requests.
///
/// The interceptor order is deliberate: the session header goes on first, then
/// the body is handed to the payload codec, then errors are translated. When
/// encryption arrives it changes nothing here — it is a different
/// `PayloadCodecInterface` binding, and the seam it plugs into already runs on
/// every request and every response.
@lazySingleton
final class DioClient {
  DioClient(this._codec)
    : dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)) {
    _installInterceptors();
  }

  final PayloadCodecInterface _codec;

  final Dio dio;

  final MockStore mockStore = MockStore();

  String? currentAccountId;

  DateTime Function() clock = DateTime.now;

  Future<void> initMock({bool withDemoHousehold = true}) async {
    mockStore.reset();
    await MockSeed.loadCatalog(mockStore);
    if (withDemoHousehold) {
      await MockSeed.loadDemoHousehold(mockStore, now: clock());
    }
    dio.httpClientAdapter = MockHttpClientAdapter(
      MockRouter(mockStore, clock: () => clock()),
    );
  }

  void disableMock() {
    dio.httpClientAdapter = HttpClientAdapter();
  }

  void _installInterceptors() {
    dio.interceptors
      ..clear()
      ..add(SessionInterceptor(readAccountId: () => currentAccountId))
      ..add(CryptoInterceptor(_codec))
      ..add(ErrorInterceptor());
  }
}
