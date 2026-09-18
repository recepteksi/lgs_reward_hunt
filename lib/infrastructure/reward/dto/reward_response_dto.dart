import 'package:either_dart/either.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_response.dart';

part 'reward_response_dto.g.dart';

/// A reward in a parent's pool, as the server sends one.
///
/// [toEntity] turns a reward row into a [RewardEntity].
///
/// Shared with `RewardPoolRepository`, which reads the same rows back after a
/// save: one mapper is one answer about what a reward is.
@JsonSerializable()
final class RewardResponseDto extends BaseResponse {
  const RewardResponseDto({
    required this.id,
    required this.parentId,
    required this.name,
    required this.cost,
    this.category,
    this.isActive,
  });

  factory RewardResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RewardResponseDtoFromJson(json);

  final String id;

  final String parentId;

  final String name;

  final String? category;

  final int cost;

  final bool? isActive;

  @override
  Map<String, dynamic> toJson() => _$RewardResponseDtoToJson(this);

  Either<Failure, RewardEntity> toEntity() => RewardEntity.create(
    id: id,
    parentId: parentId,
    name: name,
    category: RewardCategoryEnum.fromName(category),
    cost: cost,
    isActive: isActive ?? true,
  );
}
