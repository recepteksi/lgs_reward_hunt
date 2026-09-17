import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_draft_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_pool_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/reward/value_objects/reward_pool_value_object.dart';
import 'package:lgs_reward_hunt/infrastructure/network/api_paths.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/network/failure_from_dio.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/dto/reward_pool_item_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/dto/reward_pool_item_response_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/dto/save_reward_pool_request_dto.dart';

/// The reward pool the setup step edits, over HTTP.
///
/// [poolOf] reads the parent's rewards and keeps the active ones — a retired
/// reward is history, not something on offer. Rows are parsed strictly; one
/// the domain refuses fails the whole pool. A draft id is not sent.
@LazySingleton(as: RewardPoolRepositoryInterface)
final class RewardPoolRepository implements RewardPoolRepositoryInterface {
  const RewardPoolRepository(this._client);

  final DioClient _client;

  @override
  Future<Either<Failure, RewardPoolValueObject>> standardPool() =>
      _read(ApiPaths.standardRewardPool);

  @override
  Future<Either<Failure, RewardPoolValueObject>> poolOf(String parentId) =>
      _read(ApiPaths.rewardsOfParent(parentId));

  @override
  Future<Either<Failure, RewardPoolValueObject>> savePool({
    required String parentId,
    required RewardPoolValueObject pool,
  }) async {
    try {
      final response = await _client.dio.put<List<dynamic>>(
        ApiPaths.rewardPoolOfParent(parentId),
        data: SaveRewardPoolRequestDto(
          rewards: <RewardPoolItemRequestDto>[
            for (final RewardDraftEntity reward in pool.rewards)
              RewardPoolItemRequestDto(
                id: reward.isDraft ? null : reward.id,
                name: reward.name.trim(),
                category: reward.category.name,
                cost: reward.cost,
              ),
          ],
        ).toJson(),
      );
      return _poolFrom(response.data!);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  Future<Either<Failure, RewardPoolValueObject>> _read(String path) async {
    try {
      final response = await _client.dio.get<List<dynamic>>(path);
      return _poolFrom(response.data!);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  Either<Failure, RewardPoolValueObject> _poolFrom(List<dynamic> rows) {
    final List<RewardDraftEntity> rewards = <RewardDraftEntity>[];
    for (final dynamic row in rows) {
      final dto = RewardPoolItemResponseDto.fromJson(
        Map<String, dynamic>.from(row as Map),
      );
      if (dto.isActive == false) continue;

      final reward = RewardDraftEntity.create(
        id: dto.id,
        name: dto.name,
        category: RewardCategoryEnum.fromName(dto.category),
        cost: dto.cost,
      );
      if (reward.isLeft) return Left(reward.left);
      rewards.add(reward.right);
    }
    return Right(RewardPoolValueObject(rewards));
  }
}
