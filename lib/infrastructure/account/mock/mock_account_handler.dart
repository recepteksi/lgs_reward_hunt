import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/domain/account/rules/account_rules.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_handler_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_request.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_response.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_route.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_store.dart';

/// Parents, their children, and tying the two together.
///
/// A household holds at most `AccountRules.maxChildren`, each in one of
/// `AccountRules.gradeLevels`. A parent read back never carries the password
/// or the PIN. A link code is single-use: consuming one files it under the
/// parent's spent codes and issues a fresh one, so a code offered twice
/// answers "already used" rather than "wrong code" — the difference between a
/// parent re-reading the right code and a parent hunting for a typo.
final class MockAccountHandler implements MockHandlerInterface {
  const MockAccountHandler(this._store);

  final MockStore _store;

  @override
  List<MockRoute> get routes => <MockRoute>[
    MockRoute('POST', RegExp(r'^/parents$'), _createParent),
    MockRoute('GET', RegExp(r'^/parents/([^/]+)$'), _readParent),
    MockRoute('POST', RegExp(r'^/parents/([^/]+)/children$'), _addChild),
    MockRoute('GET', RegExp(r'^/parents/([^/]+)/children$'), _childrenOf),
    MockRoute('POST', RegExp(r'^/children/link$'), _linkChild),
    MockRoute('GET', RegExp(r'^/children/([^/]+)$'), _readChild),
    MockRoute('DELETE', RegExp(r'^/children/([^/]+)$'), _removeChild),
  ];

  MockResponse _createParent(MockRequest request) {
    final name = (request.body['name'] as String? ?? CharConstants.empty)
        .trim();
    if (name.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.parentNameEmpty);
    }

    final row = <String, Object?>{
      'id': _store.nextId('parent'),
      'name': name,
      'linkCode': _store.issueLinkCode(),
      'usedLinkCodes': <String>[],
    };
    _store.parents.add(row);
    return MockResponse.created(row);
  }

  MockResponse _readParent(MockRequest request) {
    final parent = _store.findById(_store.parents, request.id);
    if (parent == null) {
      return MockResponse.fail(404, FailureMessageKey.unauthorized);
    }

    return MockResponse.ok(<String, Object?>{
      'id': parent['id'],
      'name': parent['name'],
      'email': parent['email'],
      'linkCode': parent['linkCode'],
    });
  }

  MockResponse _addChild(MockRequest request) {
    final parentId = request.id;
    if (_store.findById(_store.parents, parentId) == null) {
      return MockResponse.fail(404, FailureMessageKey.unauthorized);
    }

    final name = (request.body['name'] as String? ?? CharConstants.empty)
        .trim();
    if (name.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.childNameEmpty);
    }

    final grade =
        request.body['gradeLevel'] as int? ?? AccountRules.defaultGradeLevel;
    if (!AccountRules.gradeLevels.contains(grade)) {
      return MockResponse.fail(422, FailureMessageKey.childGradeInvalid);
    }

    if (_store.childIdsOf(parentId).length >= AccountRules.maxChildren) {
      return MockResponse.fail(409, FailureMessageKey.childLimitReached);
    }

    return MockResponse.created(_insertChild(parentId, name, request.body));
  }

  MockResponse _childrenOf(MockRequest request) => MockResponse.ok(
    _store.children
        .where((Map<String, Object?> row) => row['parentId'] == request.id)
        .toList(),
  );

  MockResponse _readChild(MockRequest request) {
    final child = _store.findById(_store.children, request.id);
    return child == null
        ? MockResponse.fail(404, FailureMessageKey.unexpectedResponse)
        : MockResponse.ok(child);
  }

  MockResponse _removeChild(MockRequest request) {
    final child = _store.findById(_store.children, request.id);
    if (child == null) {
      return MockResponse.fail(404, FailureMessageKey.unexpectedResponse);
    }

    _store.children.remove(child);
    return const MockResponse.noContent();
  }

  MockResponse _linkChild(MockRequest request) {
    final code = (request.body['linkCode'] as String? ?? CharConstants.empty)
        .trim()
        .toUpperCase();
    final name = (request.body['name'] as String? ?? CharConstants.empty)
        .trim();
    if (name.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.childNameEmpty);
    }

    for (final parent in _store.parents) {
      if (parent['linkCode'] != code) continue;
      final child = _insertChild(parent['id']! as String, name, request.body);
      (parent['usedLinkCodes']! as List<Object?>).add(code);
      parent['linkCode'] = _store.issueLinkCode();
      return MockResponse.created(child);
    }
    for (final parent in _store.parents) {
      if ((parent['usedLinkCodes']! as List<Object?>).contains(code)) {
        return MockResponse.fail(409, FailureMessageKey.linkCodeUsed);
      }
    }
    return MockResponse.fail(404, FailureMessageKey.linkCodeInvalid);
  }

  Map<String, Object?> _insertChild(
    String parentId,
    String name,
    Map<String, Object?> body,
  ) {
    final row = <String, Object?>{
      'id': _store.nextId('child'),
      'parentId': parentId,
      'name': name,
      'gradeLevel':
          body['gradeLevel'] as int? ?? AccountRules.defaultGradeLevel,
      'avatarId': body['avatarId'],
    };
    _store.children.add(row);
    return row;
  }
}
