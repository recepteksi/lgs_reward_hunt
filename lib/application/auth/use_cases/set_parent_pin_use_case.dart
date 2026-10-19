import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/auth/interfaces/auth_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/parent_pin_value_object.dart';

/// Sets the PIN, from the two entries the setup screen collected.
///
/// Both entries come in and [ParentPinValueObject.confirm] decides: four digits,
/// twice, identical. The screen shows the two boxes; it does not get to decide
/// what counts as a match.
@injectable
final class SetParentPinUseCase {
  const SetParentPinUseCase(this._repository);

  final AuthRepositoryInterface _repository;

  Future<Either<Failure, ParentEntity>> call({
    required String parentId,
    required String first,
    required String second,
  }) async {
    final pin = ParentPinValueObject.confirm(first: first, second: second);

    return switch (pin) {
      Left(:final value) => Left(value),
      Right(:final value) => await _repository.setPin(
        parentId: parentId,
        pin: value,
      ),
    };
  }
}
