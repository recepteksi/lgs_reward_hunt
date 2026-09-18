import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/value_objects/session_value_object.dart';

/// Remembers the parent who signed in, and the child whose map is showing.
///
/// Called at three moments: signing up, adding the first child, and switching
/// between children. Each of those changes what the app opens on tomorrow,
/// which is the only reason the session is stored at all.
@injectable
final class SaveSessionUseCase {
  const SaveSessionUseCase(this._repository);

  final SessionRepositoryInterface _repository;

  Future<Either<Failure, SessionValueObject>> call(
    SessionValueObject session,
  ) => _repository.save(session);
}
