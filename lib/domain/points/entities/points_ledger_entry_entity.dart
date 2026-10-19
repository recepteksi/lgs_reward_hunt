import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_entity.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/points/enums/points_reason_enum.dart';

/// One movement in a child's points ledger.
///
/// Entries are never edited or deleted — a correction is another entry. That
/// is what makes the balance reconstructible: the app can always show a parent
/// the arithmetic that produced the number on screen, which a mutable
/// `balance` field can never do.
///
/// [amount] is SIGNED. A positive entry earns, a negative one spends or holds.
/// Storing the sign on the amount rather than deriving it from [reason] means
/// summing the ledger is addition and nothing else — a `switch` in the sum is
/// a place for a new reason to be forgotten and the balance to drift.
///
/// [reference] points at whatever caused the entry — a task id, a redemption
/// id — so a ledger row can be traced back to the thing the child actually
/// did. It is null only for [PointsReasonEnum.parentAdjustment], which references
/// nothing but a parent's judgement.
///
/// [create] refuses an amount of zero: an entry that moves nothing is noise in
/// a history a parent is meant to read.
final class PointsLedgerEntryEntity extends BaseEntity {
  const PointsLedgerEntryEntity._({
    required this.id,
    required this.childId,
    required this.amount,
    required this.reason,
    required this.occurredAt,
    required this.reference,
  });

  @override
  final String id;

  final String childId;

  final int amount;

  final PointsReasonEnum reason;

  final DateTime occurredAt;

  final String? reference;

  static Either<Failure, PointsLedgerEntryEntity> create({
    required String id,
    required String childId,
    required int amount,
    required PointsReasonEnum reason,
    required DateTime occurredAt,
    String? reference,
  }) {
    if (amount == ValueConstants.zero) {
      return const Left(
        ValidationFailure(FailureMessageKey.unexpectedResponse),
      );
    }
    return Right(
      PointsLedgerEntryEntity._(
        id: id,
        childId: childId,
        amount: amount,
        reason: reason,
        occurredAt: occurredAt,
        reference: reference,
      ),
    );
  }

  bool get isEarning => amount > ValueConstants.zero;
}
