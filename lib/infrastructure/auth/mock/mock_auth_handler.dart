import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/domain/auth/rules/auth_rules.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_handler_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_request.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_response.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_route.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_store.dart';

/// Signing up, signing in, and the parent's PIN.
///
/// An email is one account: signing up with one already taken is refused. A
/// PIN is `AuthRules.pinLength` digits, and verifying one answers whether it
/// matched rather than failing, because a wrong PIN is an answer, not an
/// error.
///
/// A platform sign-in finds the parent by the email the platform shared, or
/// opens an account for it. The mock cannot verify a Firebase ID token — it
/// only refuses a missing one; the real server verifies it with the Firebase
/// Admin SDK before trusting the email.
final class MockAuthHandler implements MockHandlerInterface {
  const MockAuthHandler(this._store);

  final MockStore _store;

  @override
  List<MockRoute> get routes => <MockRoute>[
    MockRoute('POST', RegExp(r'^/auth/sign-up$'), _signUp),
    MockRoute('POST', RegExp(r'^/auth/sign-in$'), _signIn),
    MockRoute('POST', RegExp(r'^/auth/platform$'), _signInWithPlatform),
    MockRoute('POST', RegExp(r'^/parents/([^/]+)/pin$'), _setPin),
    MockRoute('POST', RegExp(r'^/parents/([^/]+)/pin/verify$'), _verifyPin),
  ];

  MockResponse _signUp(MockRequest request) {
    final name = (request.body['name'] as String? ?? CharConstants.empty)
        .trim();
    if (name.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.parentNameEmpty);
    }

    final email = _emailOf(request.body);
    if (email.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.emailInvalid);
    }

    final taken = _store.findWhere(
      _store.parents,
      (Map<String, Object?> row) => row['email'] == email,
    );
    if (taken != null) {
      return MockResponse.fail(409, FailureMessageKey.emailInUse);
    }

    final row = <String, Object?>{
      'id': _store.nextId('parent'),
      'name': name,
      'email': email,
      'password': request.body['password'],
      'pin': null,
      'linkCode': _store.issueLinkCode(),
      'usedLinkCodes': <String>[],
    };
    _store.parents.add(row);
    return MockResponse.created(row);
  }

  MockResponse _signIn(MockRequest request) {
    final row = _store.findWhere(
      _store.parents,
      (Map<String, Object?> parent) =>
          parent['email'] == _emailOf(request.body) &&
          parent['password'] == request.body['password'],
    );

    return row == null
        ? MockResponse.fail(401, FailureMessageKey.credentialsInvalid)
        : MockResponse.ok(row);
  }

  MockResponse _signInWithPlatform(MockRequest request) {
    final token = request.body['idToken'] as String? ?? CharConstants.empty;
    if (token.isEmpty) {
      return MockResponse.fail(401, FailureMessageKey.platformSignInFailed);
    }

    final email = _emailOf(request.body);
    if (email.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.emailInvalid);
    }

    final existing = _store.findWhere(
      _store.parents,
      (Map<String, Object?> row) => row['email'] == email,
    );
    if (existing != null) {
      return MockResponse.ok(<String, Object?>{
        'parent': existing,
        'isNewAccount': false,
      });
    }

    final name = (request.body['name'] as String? ?? CharConstants.empty)
        .trim();
    final row = <String, Object?>{
      'id': _store.nextId('parent'),
      'name': name.isEmpty ? email.split('@').first : name,
      'email': email,
      'password': null,
      'pin': null,
      'linkCode': _store.issueLinkCode(),
      'usedLinkCodes': <String>[],
      'provider': request.body['provider'],
    };
    _store.parents.add(row);
    return MockResponse.created(<String, Object?>{
      'parent': row,
      'isNewAccount': true,
    });
  }

  MockResponse _setPin(MockRequest request) {
    final row = _store.findById(_store.parents, request.id);
    if (row == null) {
      return MockResponse.fail(404, FailureMessageKey.unauthorized);
    }

    final pin = request.body['pin'] as String? ?? CharConstants.empty;
    if (pin.length != AuthRules.pinLength) {
      return MockResponse.fail(422, FailureMessageKey.pinInvalid);
    }

    row['pin'] = pin;
    return MockResponse.ok(row);
  }

  MockResponse _verifyPin(MockRequest request) {
    final row = _store.findById(_store.parents, request.id);
    if (row == null) {
      return MockResponse.fail(404, FailureMessageKey.unauthorized);
    }

    return MockResponse.ok(<String, Object?>{
      'ok': row['pin'] == request.body['pin'],
    });
  }

  String _emailOf(Map<String, Object?> body) =>
      (body['email'] as String? ?? CharConstants.empty).trim().toLowerCase();
}
