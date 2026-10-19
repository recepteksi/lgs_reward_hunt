/// Field names of the backend's wire contract that are not a DTO's own.
///
/// [messageKey] is where a refusal carries its `FailureMessageKey`: every
/// non-2xx body the server sends has it, the mock backend writes it, and
/// `failureFromDio` reads it. Named once, because a response field spelled two
/// ways is a failure that silently becomes "something went wrong".
abstract final class ApiFields {
  static const String messageKey = 'messageKey';
}
