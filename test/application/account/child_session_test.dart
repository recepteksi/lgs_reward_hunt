import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/add_child_use_case.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/remove_child_use_case.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../support/mock_backend.dart';

/// Which child a device opens on, through adding and removing children.
///
/// The first child added becomes the device's child, a second one does not
/// take over, and removing the device's child leaves the device on nobody
/// rather than on a child who no longer exists.
void main() {
  late AccountRepository accounts;
  late AddChildUseCase addChild;
  late RemoveChildUseCase removeChild;
  const SessionRepository session = SessionRepository();

  setUp(() async {
    final client = await mockBackend(withDemoHousehold: false);
    accounts = AccountRepository(client);
    addChild = AddChildUseCase(session, accounts);
    removeChild = RemoveChildUseCase(session, accounts);

    final parentId = (await accounts.createParent(name: 'Ayşe')).right.id;
    SharedPreferences.setMockInitialValues(<String, Object>{
      'session.parentId': parentId,
    });
  });

  test('the first child added is the one the device opens on', () async {
    final first = await addChild(
      name: 'Elif',
      gradeLevel: 8,
      avatarId: 'av_k_03',
    );
    await addChild(name: 'Kerem', gradeLevel: 7, avatarId: 'av_e_01');

    expect((await session.read()).right.activeChildId, first.right.id);
  });

  test('removing the device child leaves the device on nobody', () async {
    final child = await addChild(
      name: 'Elif',
      gradeLevel: 8,
      avatarId: 'av_k_03',
    );

    await removeChild(child.right.id);

    final stored = (await session.read()).right;
    expect(stored.hasChild, isFalse);
    expect(stored.isSignedIn, isTrue);
  });

  test('a child without a face is refused before any request', () async {
    final result = await addChild(name: 'Elif', gradeLevel: 8, avatarId: null);

    expect(result.isLeft, isTrue);
    expect((await session.read()).right.hasChild, isFalse);
  });
}
