import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/account_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/child_snapshot_cache_interface.dart';
import 'package:lgs_reward_hunt/domain/points/interfaces/points_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/reward/read_models/reward_shop_read_model.dart';

/// Assembles the reward shop from the three places its parts live.
///
/// The child, the catalogue, the ledger and the pending requests are four
/// reads, and the shop is meaningless without all four — a balance with no
/// catalogue shows nothing, a catalogue with no balance cannot say what is
/// locked. Doing them here rather than in the Cubit keeps the assembly
/// testable and keeps the Cubit orchestrating.
///
/// The three reads after the child lookup are STARTED before any of them is
/// awaited, so they run together: they do not depend on each other, and four
/// round trips one after another is a visible pause on a phone.
///
/// The first failure wins. A shop drawn from three good answers and one
/// missing one would be a shop showing a wrong balance, which is worse than a
/// shop showing an error.
///
/// The balance read is remembered in the child snapshot.
@injectable
final class GetRewardShopUseCase {
  const GetRewardShopUseCase(
    this._accounts,
    this._points,
    this._rewards,
    this._snapshots,
  );

  final AccountRepositoryInterface _accounts;
  final PointsRepositoryInterface _points;
  final RewardRepositoryInterface _rewards;

  final ChildSnapshotCacheInterface _snapshots;

  Future<Either<Failure, RewardShopReadModel>> call({
    required String childId,
  }) async {
    final childResult = await _accounts.childById(childId);
    if (childResult.isLeft) return Left(childResult.left);

    final accountFuture = _points.accountFor(childId);
    final catalogueFuture = _rewards.rewardsFor(childResult.right.parentId);
    final redemptionsFuture = _rewards.redemptionsFor(childId);

    final account = await accountFuture;
    if (account.isLeft) return Left(account.left);
    final catalogue = await catalogueFuture;
    if (catalogue.isLeft) return Left(catalogue.left);
    final redemptions = await redemptionsFuture;
    if (redemptions.isLeft) return Left(redemptions.left);

    _snapshots.write(_snapshots.snapshot.withBalance(account.right.balance));

    return Right(
      RewardShopReadModel(
        account: account.right,
        rewards: catalogue.right,
        redemptions: redemptions.right,
      ),
    );
  }
}
