import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/validators/contained_in_validator.dart';
import 'package:lgs_reward_hunt/domain/account/rules/account_rules.dart';

/// A school year the app is for — one of `AccountRules.gradeLevels`.
final class GradeLevelValueObject extends BaseValueObject<int> {
  const GradeLevelValueObject(super.value);

  @override
  List<BaseValueValidator<int>> get validators =>
      const <BaseValueValidator<int>>[
        ContainedInValidator<int>(
          AccountRules.gradeLevels,
          FailureMessageKey.childGradeInvalid,
        ),
      ];
}
