import 'package:dio/dio.dart';

/// One request as a mock handler sees it: the body, the query, and the id the
/// route pulled out of the path.
///
/// [pathId] is the route pattern's first group — the `{id}` in
/// `/children/{id}/tasks` — or null for a route with none. [body] is the JSON
/// object sent, or an empty map; [query] the query parameters.
final class MockRequest {
  const MockRequest({
    required this.body,
    required this.query,
    required this.pathId,
  });

  factory MockRequest.from(RequestOptions options, RegExpMatch match) =>
      MockRequest(
        body: options.data is Map
            ? Map<String, Object?>.from(options.data as Map)
            : const <String, Object?>{},
        query: options.queryParameters,
        pathId: match.groupCount > 0 ? match.group(1) : null,
      );

  final Map<String, Object?> body;

  final Map<String, Object?> query;

  final String? pathId;

  String get id => pathId!;
}
