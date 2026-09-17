import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/reward/app_reward_card.dart';

/// Section 06: the reward card, in the four states of a redemption.
///
/// Laid out two by two, which is the shop's own grid — a card designed in a
/// full-width column looks fine and then loses its price to an ellipsis at half
/// the width. The one that cannot be afforded sits beside the ones that can, on
/// purpose: hiding it would remove the only thing on the screen a student is
/// saving towards.
class UiKitRewardsSection extends StatelessWidget {
  const UiKitRewardsSection({super.key});

  static const int _columns = 2;

  static const double _aspectRatio = 0.78;

  static const int _availableCost = 120;

  static const int _lockedCost = 5000;

  static const double _lockedProgress = 0.24;

  static const int _pendingCost = 350;

  static const int _approvedCost = 150;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: _columns,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: _aspectRatio,
      children: const <Widget>[
        AppRewardCard.available(
          title: '1 saat ekstra oyun',
          cost: _availableCost,
          icon: AppIcons.categoryScreen,
          footer: 'Alınabilir',
        ),
        AppRewardCard.locked(
          title: 'Kablosuz kulaklık',
          cost: _lockedCost,
          icon: AppIcons.categoryOther,
          footer: '4.520 puan daha',
          progress: _lockedProgress,
        ),
        AppRewardCard.pending(
          title: 'Sinema bileti',
          cost: _pendingCost,
          icon: AppIcons.categoryFun,
          footer: 'Annen onayını bekliyor',
        ),
        AppRewardCard.approved(
          title: 'Hafta sonu geç yatma',
          cost: _approvedCost,
          icon: AppIcons.categoryTreat,
          footer: 'Onaylandı · cumartesi',
        ),
      ],
    );
  }
}
