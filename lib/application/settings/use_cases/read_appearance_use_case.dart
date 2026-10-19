import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/settings/interfaces/appearance_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/settings/value_objects/appearance_settings_value_object.dart';

/// Reads back how the student left the app looking.
///
/// It is the first thing that happens on launch and it happens before the first
/// frame, so the app never shows the default blue for a moment and then snaps
/// to pink — which is the visual bug that makes an app feel like it forgot you.
@injectable
final class ReadAppearanceUseCase {
  const ReadAppearanceUseCase(this._repository);

  final AppearanceRepositoryInterface _repository;

  Future<Either<Failure, AppearanceSettingsValueObject>> call() =>
      _repository.read();
}
