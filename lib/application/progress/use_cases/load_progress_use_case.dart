import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/child_snapshot_cache_interface.dart';
import 'package:lgs_reward_hunt/domain/points/interfaces/points_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/progress/read_models/progress_read_model.dart';
import 'package:lgs_reward_hunt/domain/progress/rules/progress_rules.dart';
import 'package:lgs_reward_hunt/domain/task/interfaces/task_repository_interface.dart';

/// Reads a child's progress: their ledger and a school year of tasks.
///
/// Both reads start together — they do not depend on each other — and the
/// first failure wins. The figures themselves are the value object's; this
/// only fetches what they are worked out from. `now` is passed in so a test can
/// stand on any day.
///
/// The balance read is remembered in the child snapshot.
@injectable
final class LoadProgressUseCase {
  const LoadProgressUseCase(this._points, this._tasks, this._snapshots);

  final PointsRepositoryInterface _points;

  final TaskRepositoryInterface _tasks;

  final ChildSnapshotCacheInterface _snapshots;

  Future<Either<Failure, ProgressReadModel>> call({
    required String childId,
    required DateTime now,
  }) async {
    final DateTime today = DateTime(now.year, now.month, now.day);
    final accountFuture = _points.accountFor(childId);
    final tasksFuture = _tasks.tasksBetween(
      childId: childId,
      from: today.subtract(const Duration(days: ProgressRules.historyDays)),
      to: DateTime(today.year, today.month + 1, 0),
    );

    final account = await accountFuture;
    if (account.isLeft) return Left(account.left);
    final tasks = await tasksFuture;
    if (tasks.isLeft) return Left(tasks.left);

    _snapshots.write(_snapshots.snapshot.withBalance(account.right.balance));

    return Right(
      ProgressReadModel(tasks: tasks.right, account: account.right, today: now),
    );
  }
}
