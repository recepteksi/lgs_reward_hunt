import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_repository_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/network/api_paths.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/network/failure_from_dio.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/dto/create_reward_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/dto/redeem_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/dto/redemption_response_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/dto/reject_redemption_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/dto/reward_response_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/dto/update_reward_request_dto.dart';

/// The shop and the approval queue, over HTTP.
///
/// [redeem] is one request on purpose. Checking the balance in the app and
/// then posting a redemption is two steps with a gap between them, and two
/// taps in that gap both pass the check — the server has to decide, in the
/// same operation that takes the points, and this method carries that whole
/// decision in a single call.
///
/// [approve] sends nothing but the id: the amount was fixed when the child
/// asked, and letting the client resend it would be letting the client name
/// the price after the fact.
@LazySingleton(as: RewardRepositoryInterface)
final class RewardRepository implements RewardRepositoryInterface {
  const RewardRepository(this._client);

  final DioClient _client;

  @override
  Future<Either<Failure, List<RewardEntity>>> rewardsFor(
    String parentId,
  ) async {
    try {
      final response = await _client.dio.get<List<dynamic>>(
        ApiPaths.rewardsOfParent(parentId),
      );
      final rewards = <RewardEntity>[];
      for (final row in response.data!) {
        final parsed = RewardResponseDto.fromJson(
          Map<String, dynamic>.from(row as Map),
        ).toEntity();
        if (parsed.isLeft) return Left(parsed.left);
        rewards.add(parsed.right);
      }
      rewards.sort(
        (RewardEntity a, RewardEntity b) => a.cost.compareTo(b.cost),
      );
      return Right(rewards);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, RewardEntity>> createReward({
    required String parentId,
    required String name,
    required RewardCategoryEnum category,
    required int cost,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.rewardsOfParent(parentId),
        data: CreateRewardRequestDto(
          name: name,
          category: category.name,
          cost: cost,
        ).toJson(),
      );
      return RewardResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, RewardEntity>> updateReward({
    required String rewardId,
    int? cost,
    bool? isActive,
  }) async {
    try {
      final response = await _client.dio.patch<Map<String, dynamic>>(
        ApiPaths.reward(rewardId),
        data: UpdateRewardRequestDto(cost: cost, isActive: isActive).toJson(),
      );
      return RewardResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, void>> removeReward({required String rewardId}) async {
    try {
      await _client.dio.delete<void>(ApiPaths.reward(rewardId));
      return const Right(null);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, RedemptionEntity>> redeem({
    required String childId,
    required String rewardId,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.redemptionsOfChild(childId),
        data: RedeemRequestDto(rewardId: rewardId).toJson(),
      );
      return RedemptionResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, List<RedemptionEntity>>> redemptionsFor(
    String childId,
  ) => _redemptionList(ApiPaths.redemptionsOfChild(childId));

  @override
  Future<Either<Failure, List<RedemptionEntity>>> pendingForParent(
    String parentId,
  ) => _redemptionList(ApiPaths.redemptionsOfParent(parentId));

  @override
  Future<Either<Failure, RedemptionEntity>> approve({
    required String redemptionId,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.approveRedemption(redemptionId),
      );
      return RedemptionResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, RedemptionEntity>> reject({
    required String redemptionId,
    String? note,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.rejectRedemption(redemptionId),
        data: RejectRedemptionRequestDto(note: note).toJson(),
      );
      return RedemptionResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  Future<Either<Failure, List<RedemptionEntity>>> _redemptionList(
    String path,
  ) async {
    try {
      final response = await _client.dio.get<List<dynamic>>(path);
      final items = <RedemptionEntity>[];
      for (final row in response.data!) {
        final parsed = RedemptionResponseDto.fromJson(
          Map<String, dynamic>.from(row as Map),
        ).toEntity();
        if (parsed.isLeft) return Left(parsed.left);
        items.add(parsed.right);
      }
      items.sort(
        (RedemptionEntity a, RedemptionEntity b) =>
            b.requestedAt.compareTo(a.requestedAt),
      );
      return Right(items);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }
}
