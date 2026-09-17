// ignore_for_file: prefer_initializing_formals

import 'package:lgs_reward_hunt/core/constants/char_constants.dart';

/// One route's address, composable with the routes nested under it.
///
/// A `GoRouter` needs each route twice: the full path to navigate to
/// (`/tasks/new`) and the segment to register it under (`new`, or `/tasks` at
/// the top level). Writing both by hand is how they drift, and go_router's
/// failure mode for a mismatch is a route that simply never matches.
///
/// So a [RoutePath] is built from its `parent` plus its own segment, and
/// answers both questions itself. A child names the object above it rather than
/// re-rendering its string, which is the difference between renaming a segment
/// and hunting for every path that spelled it out.
///
/// It lives in `core/` because it knows nothing about this app: it is string
/// arithmetic over path segments, the same building block `halleder-core`
/// publishes.
///
/// [path] is the full address to navigate to. A parameterised route takes the
/// value to substitute; without one it renders its own parameter name, which is
/// what a route table wants and what a call site never does. `query` appends an
/// encoded query string, so a screen that needs `?day=2026-06-13` does not
/// build one by hand.
///
/// [pathEnd] is what `GoRoute` registers: leading-slashed at the top level
/// (`/tasks`), bare below it (`new`), and with go_router's `:` prefix on the
/// parameter (`:taskId`). [parameter] is the parameter's name, for reading the
/// value back out of `GoRouterState`.
///
/// The fields are private and the constructor's parameters are not, because a
/// named parameter cannot be private in Dart — which is what the file-level
/// `prefer_initializing_formals` ignore above is for.
final class RoutePath {
  const RoutePath({
    required String pathEnd,
    RoutePath? parent,
    String? parameter,
  }) : _pathEnd = pathEnd,
       _parent = parent,
       _parameter = parameter;

  static const String _separator = CharConstants.slash;

  static const String _parameterPrefix = CharConstants.colon;

  static const String _queryPrefix = '?';

  static const String _queryPair = '=';

  static const String _queryJoin = '&';

  final String _pathEnd;

  final RoutePath? _parent;

  final String? _parameter;

  String path({String? parameter, Map<String, String>? query}) {
    final RoutePath? parent = _parent;
    final String base =
        '${parent == null ? CharConstants.empty : parent.path()}'
        '$_separator$_pathEnd';
    final String withParameter = _parameter == null
        ? base
        : '$base$_separator${parameter ?? _parameter}';

    return query == null || query.isEmpty
        ? withParameter
        : '$withParameter$_queryPrefix${_encode(query)}';
  }

  String pathEnd() {
    final String segment = _parent == null ? '$_separator$_pathEnd' : _pathEnd;

    return _parameter == null
        ? segment
        : '$segment$_separator$_parameterPrefix$_parameter';
  }

  String parameter() => _parameter ?? CharConstants.empty;

  String _encode(Map<String, String> query) => query.entries
      .map(
        (MapEntry<String, String> entry) =>
            '${Uri.encodeQueryComponent(entry.key)}$_queryPair'
            '${Uri.encodeQueryComponent(entry.value)}',
      )
      .join(_queryJoin);
}
