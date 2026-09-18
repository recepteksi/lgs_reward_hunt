import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_balance_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_balance_pill_skeleton.dart';

/// The balance of a tab that is still loading: the real pill when the balance
/// is already known, its skeleton when [balance] is null.
class AppSnapshotBalance extends StatelessWidget {
  const AppSnapshotBalance({required this.balance, super.key});

  final int? balance;

  @override
  Widget build(BuildContext context) {
    final int? balance = this.balance;
    return balance == null
        ? const AppBalancePillSkeleton()
        : AppBalancePill(balance: balance);
  }
}
