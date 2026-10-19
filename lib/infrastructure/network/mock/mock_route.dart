import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_request.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_response.dart';

/// One endpoint of the mock backend: a method, a path pattern and its handler.
///
/// The pattern is anchored and its first group, if any, is the id handed to
/// the handler as `MockRequest.pathId`. A handler file lists its routes as
/// values of this type, so the whole API a feature answers is readable at the
/// top of that file.
final class MockRoute {
  const MockRoute(this.method, this.pattern, this.handle);

  final String method;

  final RegExp pattern;

  final MockResponse Function(MockRequest request) handle;
}
