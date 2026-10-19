import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/domain/account/value_objects/child_profile_value_object.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_gender_enum.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/avatar/repositories/avatar_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';

import '../../support/mock_backend.dart';

/// The child setup step's server calls, through Dio and the mock backend.
///
/// Adding, listing and removing children, the household's limit, and the
/// catalogue arriving with each face filed under a tab.
void main() {
  late DioClient client;
  late AccountRepository accounts;

  ChildProfileValueObject profile(String name) =>
      ChildProfileValueObject.create(
        name: name,
        gradeLevel: 7,
        avatarId: 'av_e_01',
      ).right;

  setUp(() async {
    client = await mockBackend(withDemoHousehold: false);
    accounts = AccountRepository(client);
  });

  test('an added child comes back in the list with their face', () async {
    final parentId = (await accounts.createParent(name: 'Ayşe')).right.id;

    await accounts.addChild(parentId: parentId, profile: profile('Kerem'));
    final children = await accounts.childrenOf(parentId);

    expect(children.right.single.name, 'Kerem');
    expect(children.right.single.gradeLevel, 7);
    expect(children.right.single.avatarId, 'av_e_01');
  });

  test('a third child is refused by the household limit', () async {
    final parentId = (await accounts.createParent(name: 'Ayşe')).right.id;

    await accounts.addChild(parentId: parentId, profile: profile('Elif'));
    await accounts.addChild(parentId: parentId, profile: profile('Kerem'));
    final third = await accounts.addChild(
      parentId: parentId,
      profile: profile('Ali'),
    );

    expect(third.left.messageKey, FailureMessageKey.childLimitReached);
  });

  test('a removed child leaves the list', () async {
    final parentId = (await accounts.createParent(name: 'Ayşe')).right.id;
    final child = await accounts.addChild(
      parentId: parentId,
      profile: profile('Elif'),
    );

    await accounts.removeChild(child.right.id);

    expect((await accounts.childrenOf(parentId)).right, isEmpty);
  });

  test('the seeded catalogue files four faces under each tab', () async {
    client = await mockBackend();
    accounts = AccountRepository(client);

    final avatars = (await AvatarRepository(client).catalog()).right;
    final parent = await accounts.parentById(
      demoParent(client)['id']! as String,
    );

    expect(avatars.where((a) => a.isFor(AvatarGenderEnum.girl)), hasLength(4));
    expect(avatars.where((a) => a.isFor(AvatarGenderEnum.boy)), hasLength(4));
    expect(parent.right.email, demoParent(client)['email']);
  });
}
