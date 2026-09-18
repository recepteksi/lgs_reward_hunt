import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/read_models/reward_shop_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_section_header.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/rewards/items/rewards_reward_card_item.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/rewards/widgets/rewards_balance_card.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/rewards/widgets/rewards_category_chips.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/rewards/widgets/rewards_requests_list.dart';

/// The rewards tab's one body: the balance, the filter, the grid, the history.
///
/// The category filter is kept here — it is what the child is looking at, not
/// something the shop knows — and starts on all of them. The grid is two
/// columns of the kit's reward cards, cheapest first; the history under it
/// appears once there is any.
///
/// [shop] is what to show, [onRequest] asks for a reward, [busyRewardId] is one
/// being asked for and [failure] a refused request, shown above the grid.
class RewardsBody extends StatefulWidget {
  const RewardsBody({
    required this.shop,
    required this.onRequest,
    this.busyRewardId,
    this.failure,
    super.key,
  });

  final RewardShopReadModel shop;

  final ValueChanged<RewardEntity> onRequest;

  final String? busyRewardId;

  final Failure? failure;

  @override
  State<RewardsBody> createState() => _RewardsBodyState();
}

/// Holds the category filter.
class _RewardsBodyState extends State<RewardsBody> {
  static const int _columns = 2;

  static const double _cardAspect = 0.72;

  RewardCategoryEnum? _category;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final RewardShopReadModel shop = widget.shop;
    final List<RewardEntity> rewards = shop.offeredIn(_category);
    final Failure? failure = widget.failure;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxxl,
      ),
      children: <Widget>[
        RewardsBalanceCard(shop: shop),
        const SizedBox(height: AppSpacing.lg),
        RewardsCategoryChips(
          selected: _category,
          onChanged: (RewardCategoryEnum? category) =>
              setState(() => _category = category),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (failure != null) ...<Widget>[
          AppText(
            failureCopy(l10n, failure),
            type: AppTextTypeEnum.caption,
            color: palette.errorInk,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (rewards.isEmpty)
          AppText(
            l10n.rewardsEmptyCategory,
            type: AppTextTypeEnum.body,
            color: palette.onSurfaceMuted,
          )
        else
          GridView.count(
            crossAxisCount: _columns,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: _cardAspect,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              for (final RewardEntity reward in rewards)
                RewardsRewardCardItem(
                  reward: reward,
                  shop: shop,
                  isBusy: reward.id == widget.busyRewardId,
                  onRequest: () => widget.onRequest(reward),
                ),
            ],
          ),
        if (shop.redemptions.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.xl),
          AppSectionHeader(title: l10n.rewardsRequestsTitle),
          const SizedBox(height: AppSpacing.md),
          RewardsRequestsList(requests: shop.requestsNewestFirst),
        ],
      ],
    );
  }
}
