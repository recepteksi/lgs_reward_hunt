import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/core/validators/valid_parts_validator.dart';
import 'package:lgs_reward_hunt/domain/account/value_objects/avatar_choice_value_object.dart';
import 'package:lgs_reward_hunt/domain/account/value_objects/child_name_value_object.dart';
import 'package:lgs_reward_hunt/domain/account/value_objects/grade_level_value_object.dart';

/// What a parent fills in to add a child, before the child exists.
///
/// Separate from `ChildEntity` because it has no id and no parent yet — it is
/// the request, and building it IS the validation. Its parts are value objects
/// with their own rules — [ChildNameValueObject], [GradeLevelValueObject],
/// [AvatarChoiceValueObject] — checked in that order, so a profile [create]
/// answers has a name, a grade the app is for and a face, and the repository
/// never sends one the server would refuse for a reason the screen could have
/// caught.
///
/// [name], [gradeLevel] and [avatarId] are the checked values a request is
/// built from.
final class ChildProfileValueObject
    extends
        BaseValueObject<
          ({
            ChildNameValueObject name,
            GradeLevelValueObject grade,
            AvatarChoiceValueObject avatar,
          })
        > {
  const ChildProfileValueObject._(super.value);

  static Either<Failure, ChildProfileValueObject> create({
    required String name,
    required int gradeLevel,
    required String? avatarId,
  }) {
    final ChildProfileValueObject profile = ChildProfileValueObject._((
      name: ChildNameValueObject(name),
      grade: GradeLevelValueObject(gradeLevel),
      avatar: AvatarChoiceValueObject(avatarId),
    ));
    return profile.valueObject.map((_) => profile);
  }

  String get name => value.name.value;

  int get gradeLevel => value.grade.value;

  String get avatarId => value.avatar.value;

  @override
  List<
    BaseValueValidator<
      ({
        ChildNameValueObject name,
        GradeLevelValueObject grade,
        AvatarChoiceValueObject avatar,
      })
    >
  >
  get validators =>
      <
        BaseValueValidator<
          ({
            ChildNameValueObject name,
            GradeLevelValueObject grade,
            AvatarChoiceValueObject avatar,
          })
        >
      >[
        ValidPartsValidator(
          (
            ({
              ChildNameValueObject name,
              GradeLevelValueObject grade,
              AvatarChoiceValueObject avatar,
            })
            parts,
          ) => <BaseValueObject<Object?>>[
            parts.name,
            parts.grade,
            parts.avatar,
          ],
        ),
      ];
}
