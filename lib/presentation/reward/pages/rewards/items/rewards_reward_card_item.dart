import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_offer_state_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/read_models/reward_shop_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/reward_category_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/reward/app_reward_card.dart';

/// One reward in the shop grid, as the kit's card in the state the shop says.
///
/// Available: tapping it asks for it, unless a request is already on its way.
/// Locked: how much of the price is saved, and nothing to tap. Pending: waiting
/// on a parent, and nothing to tap. [reward] is the card, [shop] decides its
/// state, [isBusy] marks the one being asked for, [onRequest] asks.
class RewardsRewardCardItem extends StatelessWidget {
  const RewardsRewardCardItem({
    required this.reward,
    required this.shop,
    required this.isBusy,
    required this.onRequest,
    super.key,
  });

  static const int _percent = 100;

  final RewardEntity reward;

  final RewardShopReadModel shop;

  final bool isBusy;

  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final String icon = rewardCategoryIcon(reward.category);

    return switch (shop.stateOf(reward)) {
      RewardOfferStateEnum.available => AppRewardCard.available(
        title: reward.name,
        cost: reward.cost,
        icon: icon,
        footer: l10n.rewardsReady,
        onTap: isBusy ? null : onRequest,
      ),
      RewardOfferStateEnum.locked => AppRewardCard.locked(
        title: reward.name,
        cost: reward.cost,
        icon: icon,
        progress: shop.progressFor(reward),
        footer: l10n.rewardsSaved(
          (shop.progressFor(reward) * _percent).floor().clamp(
            ValueConstants.zero,
            _percent,
          ),
        ),
      ),
      RewardOfferStateEnum.pending => AppRewardCard.pending(
        title: reward.name,
        cost: reward.cost,
        icon: icon,
        footer: l10n.rewardsPending,
      ),
    };
  }
}
