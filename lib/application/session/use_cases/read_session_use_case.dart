import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/value_objects/session_value_object.dart';

/// Reads back who was signed in, before the first screen is chosen.
///
/// It is what decides whether the app opens on the map or on the onboarding,
/// which is why it runs in `main` rather than inside a screen: a screen that
/// asked this question would already be the wrong screen.
@injectable
final class ReadSessionUseCase {
  const ReadSessionUseCase(this._repository);

  final SessionRepositoryInterface _repository;

  Future<Either<Failure, SessionValueObject>> call() => _repository.read();
}
