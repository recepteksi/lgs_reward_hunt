import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/core/validators/not_empty_list_validator.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_draft_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/validators/named_drafts_validator.dart';
import 'package:lgs_reward_hunt/domain/task/rules/draft_rules.dart';

/// The rewards on offer, as the parent sets them up.
///
/// A value object, like the task plan it follows in setup, and edited the same
/// way: [withNewDraft], [replacing] and [without] each answer a new pool.
/// [create] is the save-time check (`NotEmptyListValidator`,
/// `NamedDraftsValidator`) — an empty pool, or a reward still without
/// a name, is refused; while editing, both are allowed.
///
/// [cheapest] and [dearest] are the summary over the list — the price range a
/// child will be saving towards — and are zero for an empty pool.
final class RewardPoolValueObject
    extends BaseValueObject<List<RewardDraftEntity>> {
  const RewardPoolValueObject(super.value);

  static const RewardPoolValueObject empty = RewardPoolValueObject(
    <RewardDraftEntity>[],
  );

  List<RewardDraftEntity> get rewards => value;

  static Either<Failure, RewardPoolValueObject> create(
    List<RewardDraftEntity> rewards,
  ) {
    final RewardPoolValueObject checked = RewardPoolValueObject(
      List<RewardDraftEntity>.unmodifiable(rewards),
    );
    return checked.valueObject.map((_) => checked);
  }

  bool get isEmpty => rewards.isEmpty;

  int get cheapest => isEmpty
      ? ValueConstants.zero
      : rewards
            .map((RewardDraftEntity reward) => reward.cost)
            .reduce((int a, int b) => a < b ? a : b);

  int get dearest => isEmpty
      ? ValueConstants.zero
      : rewards
            .map((RewardDraftEntity reward) => reward.cost)
            .reduce((int a, int b) => a > b ? a : b);

  RewardPoolValueObject withNewDraft() {
    int number = rewards.length;
    String id;
    do {
      number += ValueConstants.one;
      id = '${DraftRules.idPrefix}$number';
    } while (rewards.any((RewardDraftEntity r) => r.id == id));

    return RewardPoolValueObject(<RewardDraftEntity>[
      ...rewards,
      RewardDraftEntity.draft(id),
    ]);
  }

  RewardPoolValueObject replacing(RewardDraftEntity reward) =>
      RewardPoolValueObject(<RewardDraftEntity>[
        for (final RewardDraftEntity current in rewards)
          current.id == reward.id ? reward : current,
      ]);

  RewardPoolValueObject without(String rewardId) =>
      RewardPoolValueObject(<RewardDraftEntity>[
        for (final RewardDraftEntity current in rewards)
          if (current.id != rewardId) current,
      ]);

  @override
  List<BaseValueValidator<List<RewardDraftEntity>>> get validators =>
      const <BaseValueValidator<List<RewardDraftEntity>>>[
        NotEmptyListValidator<RewardDraftEntity>(
          FailureMessageKey.rewardPoolEmpty,
        ),
        NamedDraftsValidator(),
      ];
}
