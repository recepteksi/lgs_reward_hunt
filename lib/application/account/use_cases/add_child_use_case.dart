import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/account_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/account/value_objects/child_profile_value_object.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';

/// Adds a child to the signed-in parent's household.
///
/// The profile is built here, and building it is the validation — a blank
/// name, a grade the app is not for or a missing face stops before a request
/// is made. The first child added also becomes the one this device opens on,
/// which is what lets a parent who kills the app after this step come back to
/// a household rather than to an empty one.
@injectable
final class AddChildUseCase {
  const AddChildUseCase(this._session, this._accounts);

  final SessionRepositoryInterface _session;

  final AccountRepositoryInterface _accounts;

  Future<Either<Failure, ChildEntity>> call({
    required String name,
    required int gradeLevel,
    required String? avatarId,
  }) async {
    final profile = ChildProfileValueObject.create(
      name: name,
      gradeLevel: gradeLevel,
      avatarId: avatarId,
    );
    if (profile.isLeft) return Left(profile.left);

    final session = await _session.read();
    if (session.isLeft) return Left(session.left);

    final String? parentId = session.right.parentId;
    if (parentId == null) {
      return const Left(UnauthorizedFailure(FailureMessageKey.notSignedIn));
    }

    final child = await _accounts.addChild(
      parentId: parentId,
      profile: profile.right,
    );
    if (child.isLeft || session.right.hasChild) return child;

    final saved = await _session.save(
      session.right.copyWith(activeChildId: child.right.id),
    );
    return saved.isLeft ? Left(saved.left) : child;
  }
}
