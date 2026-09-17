import 'package:dio/dio.dart';

/// Attaches the signed-in account to every request.
///
/// There is no real auth yet, so this sends the account's id in a header
/// rather than a token. The shape is deliberately the shape a token will take:
/// when a real backend arrives, what changes is what [readAccountId] returns,
/// not a single call site.
///
/// The callback is read on EVERY request rather than captured once, because
/// the account changes while the app is running — a parent finishes setup and
/// hands the phone to their child — and a header captured at construction
/// would keep talking as the wrong person.
final class SessionInterceptor extends Interceptor {
  SessionInterceptor({required this.readAccountId});

  static const String accountHeader = 'X-Account-Id';

  final String? Function() readAccountId;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accountId = readAccountId();
    if (accountId != null) {
      options.headers[accountHeader] = accountId;
    }
    handler.next(options);
  }
}
