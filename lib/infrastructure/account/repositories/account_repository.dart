import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/account_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/account/value_objects/child_profile_value_object.dart';
import 'package:lgs_reward_hunt/infrastructure/account/dto/add_child_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/account/dto/child_response_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/account/dto/parent_response_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/network/api_paths.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/network/failure_from_dio.dart';

/// Creating accounts and tying a child to a parent, over HTTP.
///
/// Every method has the same shape on purpose: call, hand the row to the
/// entity's `create`, let the entity decide whether what came back is
/// admissible. The server validating a name does not excuse the client from
/// validating it — a payload that reaches here malformed is a bug, and the
/// entity turning it into a `Left` is how it stops at the boundary instead of
/// halfway up a widget tree.
///
/// `try`/`catch` lives here and only here, because this is the layer where
/// something can actually be thrown. Everything above it gets an
/// `Either<Failure, T>`.
@LazySingleton(as: AccountRepositoryInterface)
final class AccountRepository implements AccountRepositoryInterface {
  const AccountRepository(this._client);

  final DioClient _client;

  @override
  Future<Either<Failure, ParentEntity>> createParent({
    required String name,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.parents,
        data: <String, Object?>{'name': name},
      );
      final row = response.data!;
      return ParentResponseDto.fromJson(row).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, ParentEntity>> parentById(String parentId) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        ApiPaths.parent(parentId),
      );
      return ParentResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, ChildEntity>> addChild({
    required String parentId,
    required ChildProfileValueObject profile,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.childrenOfParent(parentId),
        data: AddChildRequestDto(
          name: profile.name,
          gradeLevel: profile.gradeLevel,
          avatarId: profile.avatarId,
        ).toJson(),
      );
      return ChildResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, List<ChildEntity>>> childrenOf(String parentId) async {
    try {
      final response = await _client.dio.get<List<dynamic>>(
        ApiPaths.childrenOfParent(parentId),
      );
      final List<ChildEntity> children = <ChildEntity>[];
      for (final dynamic row in response.data!) {
        final child = ChildResponseDto.fromJson(
          Map<String, dynamic>.from(row as Map),
        ).toEntity();
        if (child.isLeft) return Left(child.left);
        children.add(child.right);
      }
      return Right(children);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, void>> removeChild(String childId) async {
    try {
      await _client.dio.delete<void>(ApiPaths.child(childId));
      return const Right(null);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, ChildEntity>> linkChild({
    required String linkCode,
    required String name,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.childLink,
        data: <String, Object?>{'linkCode': linkCode, 'name': name},
      );
      return ChildResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, ChildEntity>> childById(String childId) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        ApiPaths.child(childId),
      );
      return ChildResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }
}
