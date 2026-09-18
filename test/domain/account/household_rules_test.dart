import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/household_read_model.dart';
import 'package:lgs_reward_hunt/domain/account/value_objects/child_profile_value_object.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_gender_enum.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_style_enum.dart';

/// The rules a household keeps before anything reaches the server.
///
/// A child profile is refused for the three things the form can get wrong, the
/// household stops offering a third child, and the parent's badge letter is
/// upper-cased the Turkish way.
ParentEntity _parent(String name) => ParentEntity.create(
  id: 'p',
  name: name,
  email: 'a@b.com',
  linkCode: 'X',
).right;

ChildEntity _child(String id, {String? avatarId}) => ChildEntity.create(
  id: id,
  parentId: 'p',
  name: id,
  avatarId: avatarId,
).right;

const AvatarEntity _face = AvatarEntity(
  id: 'av_1',
  name: 'Defne',
  gender: AvatarGenderEnum.girl,
  style: AvatarStyleEnum.long,
  skin: 0,
  hair: 0,
  shirt: 0,
  background: 0,
);

void main() {
  group('a child profile', () {
    test('is refused without a name', () {
      final result = ChildProfileValueObject.create(
        name: '  ',
        gradeLevel: 8,
        avatarId: 'av_1',
      );
      expect(result.left.messageKey, FailureMessageKey.childNameEmpty);
    });

    test('is refused for a grade the app is not for', () {
      final result = ChildProfileValueObject.create(
        name: 'Elif',
        gradeLevel: 6,
        avatarId: 'av_1',
      );
      expect(result.left.messageKey, FailureMessageKey.childGradeInvalid);
    });

    test('is refused without a face', () {
      final result = ChildProfileValueObject.create(
        name: 'Elif',
        gradeLevel: 7,
        avatarId: null,
      );
      expect(result.left.messageKey, FailureMessageKey.childAvatarMissing);
    });

    test('keeps a trimmed name when everything holds', () {
      final result = ChildProfileValueObject.create(
        name: ' Elif ',
        gradeLevel: 7,
        avatarId: 'av_1',
      );
      expect(result.right.name, 'Elif');
    });
  });

  test('a household with two children offers no third', () {
    final household = HouseholdReadModel(
      parent: _parent('Ayşe'),
      children: <ChildEntity>[_child('a'), _child('b')],
      avatars: const <AvatarEntity>[],
    );
    expect(household.canAddChild, isFalse);
    expect(household.hasChild, isTrue);
  });

  test('a child whose face left the catalogue is drawn without one', () {
    final household = HouseholdReadModel(
      parent: _parent('Ayşe'),
      children: <ChildEntity>[_child('a', avatarId: 'gone')],
      avatars: const <AvatarEntity>[_face],
    );
    expect(household.avatarOf(household.children.single), isNull);
  });

  test('a parent named with a dotted i gets a dotted capital badge', () {
    expect(_parent('ilknur').initial, 'İ');
    expect(_parent('ayşe').initial, 'A');
  });
}
