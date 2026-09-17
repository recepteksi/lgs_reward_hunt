import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/settings/enums/accent_choice_enum.dart';
import 'package:lgs_reward_hunt/domain/settings/enums/theme_choice_enum.dart';
import 'package:lgs_reward_hunt/domain/settings/interfaces/appearance_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/settings/value_objects/appearance_settings_value_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The look of the app, kept in the device's own key-value store.
///
/// Two strings, written by name rather than by index: `AccentChoiceEnum.pink` is
/// stored as `pink`, so reordering the enum cannot silently repaint every
/// installed app, which is exactly what storing `1` would do.
///
/// A value the store does not recognise — written by an older build, or edited
/// by hand — resolves to the fallback rather than failing. Losing a preference
/// is a small thing; refusing to start because of one is not.
@LazySingleton(as: AppearanceRepositoryInterface)
final class AppearanceRepository implements AppearanceRepositoryInterface {
  const AppearanceRepository();

  static const String _accentKey = 'appearance.accent';

  static const String _themeKey = 'appearance.theme';

  @override
  Future<Either<Failure, AppearanceSettingsValueObject>> read() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      return Right(
        AppearanceSettingsValueObject(
          accent: AccentChoiceEnum.fromName(preferences.getString(_accentKey)),
          theme: ThemeChoiceEnum.fromName(preferences.getString(_themeKey)),
        ),
      );
    } catch (_) {
      return const Left(StorageFailure(FailureMessageKey.storageUnavailable));
    }
  }

  @override
  Future<Either<Failure, AppearanceSettingsValueObject>> save(
    AppearanceSettingsValueObject settings,
  ) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_accentKey, settings.accent.name);
      await preferences.setString(_themeKey, settings.theme.name);

      return Right(settings);
    } catch (_) {
      return const Left(StorageFailure(FailureMessageKey.storageUnavailable));
    }
  }
}
