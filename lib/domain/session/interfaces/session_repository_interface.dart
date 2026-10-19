import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/session/value_objects/session_value_object.dart';

/// Where the app remembers who is signed in.
///
/// It survives the app being killed, which is the whole point: a student opens
/// this every day and being asked to sign in would end the habit in a week.
///
/// [read] answers [SessionValueObject.none] rather than failing when nothing has
/// been stored — a fresh install is not an error. [clear] is signing out, and
/// it is the parent's action, never the child's.
abstract interface class SessionRepositoryInterface {
  Future<Either<Failure, SessionValueObject>> read();

  Future<Either<Failure, SessionValueObject>> save(SessionValueObject session);

  Future<Either<Failure, SessionValueObject>> clear();
}
