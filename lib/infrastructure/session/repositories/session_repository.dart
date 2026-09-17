import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/value_objects/session_value_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Who is signed in, kept on the device.
///
/// Two ids in the same key-value store the appearance uses. There is no token
/// here yet because the mock backend has none; when the real one arrives it
/// joins these two, and the only file that changes is this one — which is the
/// reason the rest of the app asks a port for the session rather than reading
/// preferences itself.
///
/// A store that cannot be read leaves the app signed out rather than broken:
/// signing in again is a small cost, and refusing to start is not.
@LazySingleton(as: SessionRepositoryInterface)
final class SessionRepository implements SessionRepositoryInterface {
  const SessionRepository();

  static const String _parentKey = 'session.parentId';

  static const String _childKey = 'session.activeChildId';

  @override
  Future<Either<Failure, SessionValueObject>> read() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      return Right(
        SessionValueObject(
          parentId: preferences.getString(_parentKey),
          activeChildId: preferences.getString(_childKey),
        ),
      );
    } catch (_) {
      return const Left(StorageFailure(FailureMessageKey.storageUnavailable));
    }
  }

  @override
  Future<Either<Failure, SessionValueObject>> save(
    SessionValueObject session,
  ) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await _write(preferences, _parentKey, session.parentId);
      await _write(preferences, _childKey, session.activeChildId);

      return Right(session);
    } catch (_) {
      return const Left(StorageFailure(FailureMessageKey.storageUnavailable));
    }
  }

  @override
  Future<Either<Failure, SessionValueObject>> clear() =>
      save(SessionValueObject.none);

  Future<void> _write(
    SharedPreferences preferences,
    String key,
    String? value,
  ) async {
    if (value == null) {
      await preferences.remove(key);
      return;
    }

    await preferences.setString(key, value);
  }
}
