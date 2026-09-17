import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/auth/interfaces/auth_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/credentials_value_object.dart';

/// Creates the parent's account, and the app's first row of data.
///
/// The credentials are built here rather than in the screen, because building
/// them IS the validation: a `CredentialsValueObject` that exists has a plausible
/// email and a long enough password, so nothing downstream re-checks and
/// nothing downstream can forget to.
@injectable
final class SignUpUseCase {
  const SignUpUseCase(this._repository);

  final AuthRepositoryInterface _repository;

  Future<Either<Failure, ParentEntity>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    final credentials = CredentialsValueObject.create(
      email: email,
      password: password,
    );

    return switch (credentials) {
      Left(:final value) => Left(value),
      Right(:final value) => await _repository.signUp(
        name: name,
        credentials: value,
      ),
    };
  }
}
