import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/household_read_model.dart';
import 'package:lgs_reward_hunt/domain/account/value_objects/child_profile_value_object.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/credentials_value_object.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/email_value_object.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/parent_pin_value_object.dart';

/// What the three domain bases promise.
///
/// A value object is equal by its value and reports the first rule it breaks;
/// a composite reports its first broken part; an entity is equal by its id
/// alone; a read model is equal by everything it holds.
void main() {
  group('BaseValueObject', () {
    test('two emails typed differently are the same email', () {
      expect(
        EmailValueObject(' Ayse@Ornek.com '),
        EmailValueObject('ayse@ornek.com'),
      );
    });

    test('the first rule broken is the one reported', () {
      const pin = ParentPinValueObject('12a');

      expect(pin.isValid, isFalse);
      expect(pin.valueObject.left.messageKey, FailureMessageKey.pinInvalid);
    });

    test('a composite reports its first broken part', () {
      final result = CredentialsValueObject.create(
        email: 'not-an-email',
        password: 'short',
      );

      expect(result.left.messageKey, FailureMessageKey.emailInvalid);
    });

    test('a composite whose parts hold answers its checked values', () {
      final profile = ChildProfileValueObject.create(
        name: '  Elif ',
        gradeLevel: 8,
        avatarId: 'av_k_03',
      ).right;

      expect(profile.name, 'Elif');
      expect(profile.gradeLevel, 8);
      expect(profile.avatarId, 'av_k_03');
    });
  });

  group('BaseEntity', () {
    ChildEntity child(String id, String name) => ChildEntity.create(
      id: id,
      parentId: 'p1',
      name: name,
      gradeLevel: 8,
      avatarId: 'av_k_03',
    ).right;

    test('a renamed child is still the same child', () {
      expect(child('c1', 'Elif'), child('c1', 'Elif Nur'));
      expect(child('c1', 'Elif').hashCode, child('c1', 'Elif Nur').hashCode);
    });

    test('two children with one name are two children', () {
      expect(child('c1', 'Elif'), isNot(child('c2', 'Elif')));
    });
  });

  group('BaseReadModel', () {
    test('two loads of the same household are equal', () {
      HouseholdReadModel load() => HouseholdReadModel(
        parent: ParentEntity.create(
          id: 'p1',
          name: 'Ayşe',
          email: 'ayse@ornek.com',
          linkCode: 'ABC123',
        ).right,
        children: const <ChildEntity>[],
        avatars: const [],
      );

      expect(load(), load());
    });
  });
}
