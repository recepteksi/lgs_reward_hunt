import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/domain/points/entities/points_account_entity.dart';
import 'package:lgs_reward_hunt/domain/points/entities/points_ledger_entry_entity.dart';
import 'package:lgs_reward_hunt/domain/points/enums/points_reason_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/redemption_status_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_offer_state_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/read_models/reward_shop_read_model.dart';

/// What each card in the shop shows, decided in one place.
void main() {
  RewardEntity reward(String id, int cost, RewardCategoryEnum category) =>
      RewardEntity.create(
        id: id,
        parentId: 'p',
        name: id,
        category: category,
        cost: cost,
      ).right;

  final RewardEntity cinema = reward('cinema', 350, RewardCategoryEnum.fun);
  final RewardEntity game = reward('game', 120, RewardCategoryEnum.screen);
  final RewardEntity sweet = reward('sweet', 80, RewardCategoryEnum.treat);

  RewardShopReadModel shop({List<RedemptionEntity> redemptions = const []}) =>
      RewardShopReadModel(
        account: PointsAccountEntity(
          childId: 'c',
          entries: <PointsLedgerEntryEntity>[
            PointsLedgerEntryEntity.create(
              id: 'l',
              childId: 'c',
              amount: 140,
              reason: PointsReasonEnum.taskCompleted,
              occurredAt: DateTime(2026, 9, 1),
              reference: 't',
            ).right,
          ],
        ),
        rewards: <RewardEntity>[cinema, game, sweet],
        redemptions: redemptions,
      );

  test(
    'a card is available, locked or pending by the balance and requests',
    () {
      final withRequest = shop(
        redemptions: <RedemptionEntity>[
          RedemptionEntity(
            id: 'r',
            childId: 'c',
            rewardId: 'sweet',
            rewardName: 'sweet',
            costAtRequest: 80,
            status: RedemptionStatusEnum.pending,
            requestedAt: DateTime(2026, 9, 2),
          ),
        ],
      );

      expect(withRequest.stateOf(game), RewardOfferStateEnum.available);
      expect(withRequest.stateOf(cinema), RewardOfferStateEnum.locked);
      expect(withRequest.stateOf(sweet), RewardOfferStateEnum.pending);
    },
  );

  test('the shop is cheapest first and narrows by category', () {
    expect(shop().offered.map((r) => r.id), <String>[
      'sweet',
      'game',
      'cinema',
    ]);
    expect(shop().offeredIn(RewardCategoryEnum.fun), <RewardEntity>[cinema]);
    expect(shop().cheapestOffered, 80);
  });

  test('a locked card shows how much of its price is saved', () {
    expect(shop().progressFor(cinema), closeTo(0.4, 0.001));
    expect(shop().progressFor(sweet), 1);
  });
}
