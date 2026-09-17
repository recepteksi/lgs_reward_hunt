import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_pool_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/reward/value_objects/reward_pool_value_object.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';

/// The pool the reward setup step opens with.
///
/// The parent's active rewards if they have any — a parent who comes back to
/// this step finds what they left — and otherwise the suggested starting pool.
@injectable
final class LoadRewardPoolUseCase {
  const LoadRewardPoolUseCase(this._session, this._pools);

  final SessionRepositoryInterface _session;

  final RewardPoolRepositoryInterface _pools;

  Future<Either<Failure, RewardPoolValueObject>> call() async {
    final session = await _session.read();
    if (session.isLeft) return Left(session.left);

    final String? parentId = session.right.parentId;
    if (parentId == null) {
      return const Left(UnauthorizedFailure(FailureMessageKey.notSignedIn));
    }

    final saved = await _pools.poolOf(parentId);
    if (saved.isLeft || !saved.right.isEmpty) return saved;

    return _pools.standardPool();
  }
}
