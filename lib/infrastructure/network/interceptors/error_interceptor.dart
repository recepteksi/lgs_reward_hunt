import 'package:dio/dio.dart';

/// Turns every transport outcome into something the repositories can read.
///
/// It does not swallow anything and it does not decide what a failure means —
/// that is the repository's job, because only the repository knows which
/// endpoint was called and what a 404 means for it. What this does is make
/// sure a `DioException` always arrives with a body the repository can look
/// at, rather than a null the caller has to guess about.
///
/// [onDioError] is a hook for whatever the app wants to do besides — logging,
/// a crash reporter — without this class growing an opinion about either.
final class ErrorInterceptor extends Interceptor {
  ErrorInterceptor({this.onDioError});

  final void Function(DioException error)? onDioError;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    onDioError?.call(err);
    handler.next(err);
  }
}
