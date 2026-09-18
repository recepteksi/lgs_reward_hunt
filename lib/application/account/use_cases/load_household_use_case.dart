import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/account_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/household_read_model.dart';
import 'package:lgs_reward_hunt/domain/avatar/interfaces/avatar_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';

/// Reads the signed-in parent's household: the parent, the children, the faces.
///
/// The parent comes from the stored session, never from the screen, so a
/// screen cannot ask about somebody else's household. The three reads run one
/// after another and the first failure wins — a list of children with no way
/// to draw their faces is not a household a screen can show.
@injectable
final class LoadHouseholdUseCase {
  const LoadHouseholdUseCase(this._session, this._accounts, this._avatars);

  final SessionRepositoryInterface _session;

  final AccountRepositoryInterface _accounts;

  final AvatarRepositoryInterface _avatars;

  Future<Either<Failure, HouseholdReadModel>> call() async {
    final session = await _session.read();
    if (session.isLeft) return Left(session.left);

    final String? parentId = session.right.parentId;
    if (parentId == null) {
      return const Left(UnauthorizedFailure(FailureMessageKey.notSignedIn));
    }

    final parent = await _accounts.parentById(parentId);
    if (parent.isLeft) return Left(parent.left);

    final children = await _accounts.childrenOf(parentId);
    if (children.isLeft) return Left(children.left);

    final avatars = await _avatars.catalog();
    if (avatars.isLeft) return Left(avatars.left);

    return Right(
      HouseholdReadModel(
        parent: parent.right,
        children: children.right,
        avatars: avatars.right,
      ),
    );
  }
}
