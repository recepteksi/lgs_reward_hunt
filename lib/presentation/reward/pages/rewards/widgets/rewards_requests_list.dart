import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/rewards/items/rewards_request_row.dart';

/// The child's requests, newest first, as one card with hairlines between.
///
/// One card rather than a card each, because they are one history.
/// [requests] is the list, already in order.
class RewardsRequestsList extends StatelessWidget {
  const RewardsRequestsList({required this.requests, super.key});

  final List<RedemptionEntity> requests;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          for (final RedemptionEntity request in requests) ...<Widget>[
            if (request != requests.first)
              Divider(height: AppSizes.border, color: palette.outline),
            RewardsRequestRow(request: request),
          ],
        ],
      ),
    );
  }
}
