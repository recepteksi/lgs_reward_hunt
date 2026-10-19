/// The numbers the setup reward pool is edited with.
///
/// The stepper moves a price by [costStep] between [minCost] and [maxCost] —
/// a narrower band than `PointsRules.minRewardCost`…`maxRewardCost`, because
/// a starting pool priced at ten points or at a hundred thousand is a pool
/// set up by accident. A reward the parent adds starts at [newCost].
abstract final class RewardPoolRules {
  static const int costStep = 20;

  static const int minCost = 20;

  static const int maxCost = 5000;

  static const int newCost = 200;
}
