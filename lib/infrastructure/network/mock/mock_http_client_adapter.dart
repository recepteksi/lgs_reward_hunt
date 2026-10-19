import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_router.dart';

/// Puts the mock backend behind Dio, at the transport seam.
///
/// Swapping the [HttpClientAdapter] rather than stubbing the repositories is
/// what makes this worth having: every interceptor, the JSON encoding, the
/// status-code handling and the repositories' own parsing all run exactly as
/// they will against a real server. A mock that replaces the repository skips
/// all of it, and the first real request is then the first time any of that
/// code has executed.
///
/// [latency] is deliberately not zero. A backend that answers instantly hides
/// every missing loading state, and those only ever show up on a real phone on
/// a real network — which is the worst place to find them.
///
/// [onChanged] runs after every request that is not a `GET`, which covers every
/// request that can change the store. It is how the store gets saved.
final class MockHttpClientAdapter implements HttpClientAdapter {
  MockHttpClientAdapter(
    this._router, {
    this.latency = const Duration(milliseconds: 260),
    this.onChanged,
  });

  static const String _read = 'GET';

  final MockRouter _router;
  final Duration latency;
  final Future<void> Function()? onChanged;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await Future<void>.delayed(latency);
    final response = _router.handle(options);
    if (options.method.toUpperCase() != _read) await onChanged?.call();
    return ResponseBody.fromString(
      jsonEncode(response.body),
      response.status,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
