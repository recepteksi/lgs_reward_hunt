import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/enums/auth_provider_enum.dart';
import 'package:lgs_reward_hunt/domain/auth/interfaces/auth_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/auth/interfaces/platform_sign_in_interface.dart';
import 'package:lgs_reward_hunt/domain/auth/read_models/platform_sign_in_result_read_model.dart';

/// Signs a parent in with Google or Apple.
///
/// The platform proves who the parent is, then the app's backend opens or
/// finds their account from that proof. A sheet the parent closed comes back
/// as `FailureMessageKey.signInCancelled` and stops there.
@injectable
final class PlatformSignInUseCase {
  const PlatformSignInUseCase(this._platform, this._repository);

  final PlatformSignInInterface _platform;

  final AuthRepositoryInterface _repository;

  Future<Either<Failure, PlatformSignInResultReadModel>> call(
    AuthProviderEnum provider,
  ) async {
    final identity = await _platform.signIn(provider);
    if (identity.isLeft) return Left(identity.left);

    return _repository.signInWithPlatform(identity.right);
  }
}
