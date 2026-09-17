import 'package:lgs_reward_hunt/core/base/base_entity.dart';
import 'package:lgs_reward_hunt/domain/points/entities/points_ledger_entry_entity.dart';

/// A child's points, as the ledger that produced them.
///
/// There is no stored balance anywhere in this app. [balance] is the sum of
/// [entries], computed here, every time it is asked for. A stored balance and
/// a ledger are two sources of truth that agree right up until one write
/// fails, and the failure is silent — the number on screen is simply wrong and
/// nothing can tell you why.
///
/// [balance] is what the child may spend RIGHT NOW: points already held for a
/// pending redemption are gone from it, because the hold is a negative entry.
///
/// [earnedTotal] is every positive entry ever — the number that only goes up,
/// and the one worth showing a child who has just spent everything.
///
/// [canAfford] is the single place that answers whether a cost fits, so the
/// shop, the redeem action and the mock backend cannot disagree about it.
///
/// How much is sitting in pending requests is deliberately NOT here. The
/// ledger cannot tell an approved redemption from a pending one — both are a
/// hold with no release — so that number is the redemptions' business, and
/// asking this entity for it would produce a confident wrong answer.
final class PointsAccountEntity extends BaseEntity {
  const PointsAccountEntity({required this.childId, required this.entries});

  final String childId;

  final List<PointsLedgerEntryEntity> entries;

  int get balance =>
      entries.fold(0, (int sum, PointsLedgerEntryEntity e) => sum + e.amount);

  int get earnedTotal => entries
      .where((PointsLedgerEntryEntity e) => e.isEarning)
      .fold(0, (int sum, PointsLedgerEntryEntity e) => sum + e.amount);

  bool canAfford(int cost) => cost <= balance;

  @override
  String get id => childId;
}
