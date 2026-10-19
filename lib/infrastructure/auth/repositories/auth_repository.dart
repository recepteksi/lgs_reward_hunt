import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/auth/interfaces/auth_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/auth/read_models/platform_sign_in_result_read_model.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/credentials_value_object.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/parent_pin_value_object.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/platform_identity_value_object.dart';
import 'package:lgs_reward_hunt/infrastructure/account/dto/parent_response_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/dto/parent_pin_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/dto/parent_pin_response_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/dto/platform_sign_in_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/dto/platform_sign_in_response_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/dto/sign_in_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/auth/dto/sign_up_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/network/api_paths.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/network/failure_from_dio.dart';

/// Signing up, signing in, and the parent's PIN, over HTTP.
///
/// Every request goes out as a DTO and every answer is read as one, so a key
/// is spelled in exactly one place and a field the backend renames breaks here
/// rather than showing up as a null on a screen.
///
/// The credentials arrive already validated as a [CredentialsValueObject], so this
/// file has no opinion about what an email looks like — that belongs to the
/// domain, where it can be checked once and trusted everywhere. What it does
/// own is the shape of the request and the mapping of the answer, which is the
/// only thing that changes when the real backend arrives.
///
/// [verifyPin] reads a flag rather than a status code, because a wrong PIN is
/// an expected answer on that screen and not a failure to report.
@LazySingleton(as: AuthRepositoryInterface)
final class AuthRepository implements AuthRepositoryInterface {
  const AuthRepository(this._client);

  final DioClient _client;

  @override
  Future<Either<Failure, ParentEntity>> signUp({
    required String name,
    required CredentialsValueObject credentials,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.authSignUp,
        data: SignUpRequestDto(
          name: name,
          email: credentials.email,
          password: credentials.password,
        ).toJson(),
      );

      return ParentResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, ParentEntity>> signIn(
    CredentialsValueObject credentials,
  ) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.authSignIn,
        data: SignInRequestDto(
          email: credentials.email,
          password: credentials.password,
        ).toJson(),
      );

      return ParentResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, PlatformSignInResultReadModel>> signInWithPlatform(
    PlatformIdentityValueObject identity,
  ) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.authPlatform,
        data: PlatformSignInRequestDto(
          provider: identity.provider.name,
          idToken: identity.idToken,
          email: identity.email,
          name: identity.displayName,
        ).toJson(),
      );
      final dto = PlatformSignInResponseDto.fromJson(response.data!);
      final parent = dto.parent.toEntity();
      if (parent.isLeft) return Left(parent.left);
      _client.currentAccountId = parent.right.id;
      return Right(
        PlatformSignInResultReadModel(
          parent: parent.right,
          isNewAccount: dto.isNewAccount,
        ),
      );
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, ParentEntity>> setPin({
    required String parentId,
    required ParentPinValueObject pin,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.parentPin(parentId),
        data: ParentPinRequestDto(pin: pin.value).toJson(),
      );

      return ParentResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPin({
    required String parentId,
    required String pin,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.parentPinVerify(parentId),
        data: ParentPinRequestDto(pin: pin).toJson(),
      );

      return Right(ParentPinResponseDto.fromJson(response.data!).ok);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }
}
