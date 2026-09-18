import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/settings/interfaces/appearance_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/settings/value_objects/appearance_settings_value_object.dart';

/// Remembers a change to the look of the app.
///
/// Saving is not what makes the change visible — the Cubit emits the new
/// settings first and stores them second, because a student tapping a colour
/// should see it immediately and not after a disk write. What this use case
/// protects is the NEXT launch.
@injectable
final class SaveAppearanceUseCase {
  const SaveAppearanceUseCase(this._repository);

  final AppearanceRepositoryInterface _repository;

  Future<Either<Failure, AppearanceSettingsValueObject>> call(
    AppearanceSettingsValueObject settings,
  ) => _repository.save(settings);
}
