/// Where a redemption request has got to.
///
/// [pending] is asked for and waiting on a parent. The points are already
/// gone from the child's balance at this point — see `PointsReasonEnum` — so a
/// pending request cannot be paid for twice.
///
/// [approved] is the parent saying yes; the held points become spent and
/// nothing further moves. [rejected] is the parent saying no, and it is the
/// only status that gives points back.
enum RedemptionStatusEnum { pending, approved, rejected }
