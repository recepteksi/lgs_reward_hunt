import 'package:dio/dio.dart';
import 'package:lgs_reward_hunt/infrastructure/network/crypto/payload_codec_interface.dart';

/// Runs the payload codec on the way out and on the way back.
///
/// It is the only place in the app that knows a body might not travel as it was
/// written. A repository builds a request DTO and reads a response DTO; between
/// those two moments this interceptor is free to wrap the map in an envelope,
/// and neither side is written differently because of it.
///
/// Only map bodies pass through the codec. A multipart upload or a query-only
/// request has nothing to encode, and forcing one through would corrupt it —
/// which is the same reason Recipely's interceptor leaves `FormData` alone.
final class CryptoInterceptor extends Interceptor {
  const CryptoInterceptor(this._codec);

  final PayloadCodecInterface _codec;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final Object? data = options.data;

    if (data is Map<String, dynamic>) {
      options.data = _codec.encode(data);
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final Object? data = response.data;

    if (data is Map<String, dynamic>) {
      response.data = _codec.decode(data);
    }

    handler.next(response);
  }
}
