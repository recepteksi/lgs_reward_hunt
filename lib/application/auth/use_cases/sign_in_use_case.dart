import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/auth/interfaces/auth_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/credentials_value_object.dart';

/// Lets a parent back into an account they already have.
///
/// It validates before it asks, for the same reason `SignUpUseCase` does: a
/// mistyped email should be answered on the device rather than by a round trip,
/// and the check is the entity's, not the screen's.
@injectable
final class SignInUseCase {
  const SignInUseCase(this._repository);

  final AuthRepositoryInterface _repository;

  Future<Either<Failure, ParentEntity>> call({
    required String email,
    required String password,
  }) async {
    final credentials = CredentialsValueObject.existing(
      email: email,
      password: password,
    );

    return switch (credentials) {
      Left(:final value) => Left(value),
      Right(:final value) => await _repository.signIn(value),
    };
  }
}
