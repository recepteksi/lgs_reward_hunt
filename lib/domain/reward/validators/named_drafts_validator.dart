import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_draft_entity.dart';

/// Passes a pool whose every reward has a name.
final class NamedDraftsValidator
    extends BaseValueValidator<List<RewardDraftEntity>> {
  const NamedDraftsValidator();

  @override
  Either<Failure, List<RewardDraftEntity>> validate(
    List<RewardDraftEntity> value,
  ) => value.every((RewardDraftEntity reward) => reward.hasName)
      ? Right(value)
      : const Left(ValidationFailure(FailureMessageKey.rewardNameEmpty));
}
