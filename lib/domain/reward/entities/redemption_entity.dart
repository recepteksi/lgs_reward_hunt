import 'package:lgs_reward_hunt/core/base/base_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/redemption_status_enum.dart';

/// A child's request to spend points on a reward, and what came of it.
///
/// [costAtRequest] is a COPY of the reward's price at the moment it was asked
/// for, not a lookup. A parent who re-prices a reward while a request is
/// pending must not change what the child already agreed to pay, and a
/// redemption from last month has to keep showing what it actually cost.
///
/// [rewardName] is copied for the same reason: the history has to stay
/// readable after a reward is retired or renamed.
///
/// [decidedAt] and [parentNote] are filled by the parent's decision. The note
/// exists for rejections — a bare "no" with no reason is the version of this
/// feature that makes a child stop asking.
///
/// [isPending] is what an approve or reject must check before doing anything;
/// deciding an already-decided request would write a second points movement
/// for one purchase.
final class RedemptionEntity extends BaseEntity {
  const RedemptionEntity({
    required this.id,
    required this.childId,
    required this.rewardId,
    required this.rewardName,
    required this.costAtRequest,
    required this.status,
    required this.requestedAt,
    this.decidedAt,
    this.parentNote,
  });

  @override
  final String id;

  final String childId;

  final String rewardId;

  final String rewardName;

  final int costAtRequest;

  final RedemptionStatusEnum status;

  final DateTime requestedAt;

  final DateTime? decidedAt;

  final String? parentNote;

  bool get isPending => status == RedemptionStatusEnum.pending;

  bool get isApproved => status == RedemptionStatusEnum.approved;
}
