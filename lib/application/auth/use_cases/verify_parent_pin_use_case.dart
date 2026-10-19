import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/interfaces/auth_repository_interface.dart';

/// Checks the PIN at the door to the parent's screens.
///
/// It answers `false` for a wrong code rather than failing: on that screen a
/// wrong code is the expected case, and treating it as an error would put a red
/// card in front of a parent who simply fat-fingered a digit.
@injectable
final class VerifyParentPinUseCase {
  const VerifyParentPinUseCase(this._repository);

  final AuthRepositoryInterface _repository;

  Future<Either<Failure, bool>> call({
    required String parentId,
    required String pin,
  }) => _repository.verifyPin(parentId: parentId, pin: pin);
}
