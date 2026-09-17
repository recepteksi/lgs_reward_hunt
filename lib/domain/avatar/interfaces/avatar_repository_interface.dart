import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';

/// Where the catalogue of faces comes from.
///
/// A port, even though the catalogue could have been a constant in the app: it
/// is content, it changes without a release, and the screen that shows it has a
/// loading and a failed state precisely because it is a fetch. Building it as a
/// list in Dart would mean writing those states again the day it moves.
abstract interface class AvatarRepositoryInterface {
  Future<Either<Failure, List<AvatarEntity>>> catalog();
}
