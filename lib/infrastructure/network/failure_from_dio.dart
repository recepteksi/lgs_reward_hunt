import 'package:dio/dio.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/infrastructure/network/api_fields.dart';

/// Turns whatever the transport threw into a [Failure] the app can act on.
///
/// The ONE place that mapping happens. Written per repository it becomes four
/// slightly different opinions about what a 409 means, and the first one that
/// is wrong shows a user the generic apology for a problem the server
/// explained perfectly well.
///
/// The server's own [ApiFields.messageKey] is preferred over anything
/// inferred from the status code: the backend knows it refused because the
/// balance was short, and the status code only knows it was a conflict. The
/// status is the fallback, and it decides the [Failure] VARIANT — which is
/// what callers switch on — while the key decides the words.
///
/// A response that is not JSON, or JSON without a key, is
/// [FailureMessageKey.unexpectedResponse] rather than a crash: a proxy
/// returning an HTML error page is a normal thing to meet on a phone network.
Failure failureFromDio(Object error) {
  if (error is! DioException) {
    return const UnknownFailure(FailureMessageKey.unknown);
  }

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure(FailureMessageKey.network);
    case DioExceptionType.transformTimeout:
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
    case DioExceptionType.badResponse:
      break;
  }

  final data = error.response?.data;
  final key = data is Map && data[ApiFields.messageKey] is String
      ? data[ApiFields.messageKey] as String
      : FailureMessageKey.unexpectedResponse;

  return switch (error.response?.statusCode) {
    401 || 403 => UnauthorizedFailure(key),
    404 => NotFoundFailure(key),
    409 || 422 => ValidationFailure(key),
    null => const NetworkFailure(FailureMessageKey.network),
    _ => UnknownFailure(key),
  };
}
