/// Why a points ledger entry exists.
///
/// The ledger is append-only and the balance is the sum of its entries, so
/// every movement has to name itself: a balance nobody can explain is a
/// balance a parent will not trust, and "where did my 200 points go" is the
/// first question this product gets asked.
///
/// [taskCompleted] adds a task's reward. [dayCompletionBonus] adds the bonus
/// for finishing every task scheduled for a day.
///
/// [redemptionHeld] SUBTRACTS a reward's cost the moment the child asks for
/// it, before any parent has looked at it. This is the entry that keeps the
/// economy honest: without it the same points can be spent on three rewards
/// while all three sit waiting for approval. [redemptionReleased] adds the
/// cost back when a parent rejects the request. An approval writes no entry at
/// all — the hold already took the points, and approving is a decision about
/// the request, not about the balance.
///
/// [parentAdjustment] is a manual correction, in either direction, for
/// everything the rules did not foresee.
enum PointsReasonEnum {
  taskCompleted,
  dayCompletionBonus,
  redemptionHeld,
  redemptionReleased,
  parentAdjustment,
}
