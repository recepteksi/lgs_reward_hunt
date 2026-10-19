import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/settings/value_objects/appearance_settings_value_object.dart';

/// Where the look of the app is remembered between launches.
///
/// It is a port like any other, even though what it talks to is a file on the
/// device rather than a server: the rule is that `application` never knows what
/// is behind it, and a preference that today lives in local storage may
/// tomorrow follow the account onto a second device.
///
/// [read] answers with [AppearanceSettingsValueObject.initial] rather than a failure when
/// nothing has been stored yet — a first launch is not an error. A failure here
/// means the store itself could not be reached.
abstract interface class AppearanceRepositoryInterface {
  Future<Either<Failure, AppearanceSettingsValueObject>> read();

  Future<Either<Failure, AppearanceSettingsValueObject>> save(
    AppearanceSettingsValueObject settings,
  );
}
