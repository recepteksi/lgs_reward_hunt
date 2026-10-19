import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/account_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';

/// Takes a child back out of the household while setup is still open.
///
/// If the child was the one this device opens on, the session forgets them
/// too: a device pointing at a child who no longer exists opens on a map that
/// cannot load.
@injectable
final class RemoveChildUseCase {
  const RemoveChildUseCase(this._session, this._accounts);

  final SessionRepositoryInterface _session;

  final AccountRepositoryInterface _accounts;

  Future<Either<Failure, void>> call(String childId) async {
    final removed = await _accounts.removeChild(childId);
    if (removed.isLeft) return removed;

    final session = await _session.read();
    if (session.isLeft) return Left(session.left);
    if (session.right.activeChildId != childId) return removed;

    final saved = await _session.save(session.right.withoutChild());
    return saved.isLeft ? Left(saved.left) : removed;
  }
}
