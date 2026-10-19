import 'package:lgs_reward_hunt/infrastructure/network/api_fields.dart';

/// What a mock handler answers: a status and a JSON-encodable body.
///
/// `fail` is the backend's failure contract — a non-2xx status carrying
/// `ApiFields.messageKey` — written once, so every handler refuses the same way and the
/// repositories' error mapping is exercised against the shape a real server
/// will send.
final class MockResponse {
  const MockResponse(this.status, this.body);

  const MockResponse.ok(this.body) : status = 200;

  const MockResponse.created(this.body) : status = 201;

  const MockResponse.noContent() : status = 204, body = null;

  factory MockResponse.fail(int status, String messageKey) =>
      MockResponse(status, <String, Object?>{ApiFields.messageKey: messageKey});

  final int status;

  final Object? body;
}
