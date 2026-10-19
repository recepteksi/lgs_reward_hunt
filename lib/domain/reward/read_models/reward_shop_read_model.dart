import 'package:lgs_reward_hunt/core/base/base_read_model.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/points/entities/points_account_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_offer_state_enum.dart';

/// Everything the reward shop needs to draw itself, in one value.
///
/// The shop is the one screen that cannot be built from a single repository:
/// what it shows depends on the catalogue, the balance AND what is already
/// waiting on a parent. Assembling those three in the widget would put the
/// arithmetic somewhere no test can reach, so they are assembled here and the
/// screen renders what it is given.
///
/// [heldForApproval] lives here rather than on [PointsAccountEntity] for a
/// reason worth keeping: the ledger cannot tell an approved redemption from a
/// pending one — both are a hold with no release — so only something holding
/// the redemptions can answer it. This is that something.
///
/// [affordable] and [locked] split the catalogue the way the design does, and
/// [shortfallFor] is what the locked card prints. A locked reward is shown,
/// never hidden: a target the child cannot see is a target that motivates
/// nobody.
///
/// For the shop page: [offered] is the active catalogue cheapest first and
/// [offeredIn] the same narrowed to a category (all of it for null).
/// [stateOf] is a card's state — pending if [pendingFor] finds a request
/// waiting on it, otherwise available or locked by the balance — and
/// [progressFor] how much of its price the balance covers. [cheapestOffered]
/// is the nearest goal, and [requestsNewestFirst] the child's history.
final class RewardShopReadModel extends BaseReadModel {
  const RewardShopReadModel({
    required this.account,
    required this.rewards,
    required this.redemptions,
  });

  final PointsAccountEntity account;

  final List<RewardEntity> rewards;

  final List<RedemptionEntity> redemptions;

  int get balance => account.balance;

  int get heldForApproval => redemptions
      .where((RedemptionEntity r) => r.isPending)
      .fold(0, (int sum, RedemptionEntity r) => sum + r.costAtRequest);

  List<RewardEntity> get affordable => rewards
      .where((RewardEntity r) => r.affordableWith(account.balance))
      .toList();

  List<RewardEntity> get locked => rewards
      .where(
        (RewardEntity r) => r.isActive && !r.affordableWith(account.balance),
      )
      .toList();

  List<RedemptionEntity> get pending =>
      redemptions.where((RedemptionEntity r) => r.isPending).toList();

  int shortfallFor(RewardEntity reward) =>
      reward.shortfallFrom(account.balance);

  List<RewardEntity> get offered =>
      rewards.where((RewardEntity r) => r.isActive).toList()
        ..sort((RewardEntity a, RewardEntity b) => a.cost.compareTo(b.cost));

  List<RewardEntity> offeredIn(RewardCategoryEnum? category) => category == null
      ? offered
      : offered.where((RewardEntity r) => r.category == category).toList();

  int? get cheapestOffered => offered.isEmpty ? null : offered.first.cost;

  RedemptionEntity? pendingFor(RewardEntity reward) {
    for (final RedemptionEntity redemption in redemptions) {
      if (redemption.isPending && redemption.rewardId == reward.id) {
        return redemption;
      }
    }
    return null;
  }

  RewardOfferStateEnum stateOf(RewardEntity reward) {
    if (pendingFor(reward) != null) return RewardOfferStateEnum.pending;
    return reward.affordableWith(balance)
        ? RewardOfferStateEnum.available
        : RewardOfferStateEnum.locked;
  }

  double progressFor(RewardEntity reward) => reward.cost <= ValueConstants.zero
      ? ValueConstants.oneDouble
      : (balance / reward.cost)
            .clamp(ValueConstants.zeroDouble, ValueConstants.oneDouble)
            .toDouble();

  List<RedemptionEntity> get requestsNewestFirst =>
      List<RedemptionEntity>.of(redemptions)..sort(
        (RedemptionEntity a, RedemptionEntity b) =>
            b.requestedAt.compareTo(a.requestedAt),
      );

  @override
  List<Object?> get props => <Object?>[account, rewards, redemptions];
}
