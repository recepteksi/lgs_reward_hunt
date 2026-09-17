part of 'rewards_cubit.dart';

/// What the rewards tab is showing.
sealed class RewardsState {
  const RewardsState();
}

/// The first load is on its way. [snapshot] is what is already known about
/// the child — shown at once, with skeletons only where it has nothing.
final class RewardsLoading extends RewardsState {
  const RewardsLoading(this.snapshot);

  final ChildSnapshotReadModel snapshot;
}

/// The shop could not be read; the tab is a retry.
final class RewardsFailed extends RewardsState {
  const RewardsFailed(this.failure);

  final Failure failure;
}

/// Every state that has a shop on screen: [header] is whose it is.
sealed class RewardsShowing extends RewardsState {
  const RewardsShowing(this.header, this.shop);

  final ChildHeaderReadModel header;

  final RewardShopReadModel shop;
}

/// The shop.
final class RewardsReady extends RewardsShowing {
  const RewardsReady(super.header, super.shop);
}

/// A request is on its way; [rewardId] is the reward asked for.
final class RewardsRequesting extends RewardsShowing {
  const RewardsRequesting(super.header, super.shop, this.rewardId);

  final String rewardId;
}

/// A request went through; [rewardName] is what was asked for.
final class RewardsRequested extends RewardsShowing {
  const RewardsRequested(super.header, super.shop, this.rewardName);

  final String rewardName;
}

/// A request was refused; [failure] says why.
final class RewardsRequestFailed extends RewardsShowing {
  const RewardsRequestFailed(super.header, super.shop, this.failure);

  final Failure failure;
}
