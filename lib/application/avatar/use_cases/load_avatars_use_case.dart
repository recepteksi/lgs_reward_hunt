import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/interfaces/avatar_repository_interface.dart';

/// Fetches the faces a child can choose from.
///
/// It is a fetch and it is allowed to be slow or to fail — the setup screen has
/// a waiting state and a retry for exactly that. A catalogue baked into the app
/// would have neither, and would need a release to add a face.
@injectable
final class LoadAvatarsUseCase {
  const LoadAvatarsUseCase(this._repository);

  final AvatarRepositoryInterface _repository;

  Future<Either<Failure, List<AvatarEntity>>> call() => _repository.catalog();
}
