import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_response.dart';

part 'reward_pool_item_response_dto.g.dart';

/// One reward of a pool, as the server sends it — the suggested pool, or a
/// parent's active rewards read back. It carries what the setup step edits
/// and nothing about who owns it.
@JsonSerializable()
final class RewardPoolItemResponseDto extends BaseResponse {
  const RewardPoolItemResponseDto({
    required this.id,
    required this.name,
    required this.cost,
    this.category,
    this.isActive,
  });

  factory RewardPoolItemResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RewardPoolItemResponseDtoFromJson(json);

  final String id;

  final String name;

  final String? category;

  final int cost;

  final bool? isActive;

  @override
  Map<String, dynamic> toJson() => _$RewardPoolItemResponseDtoToJson(this);
}
