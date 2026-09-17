import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'reward_pool_item_request_dto.g.dart';

/// One reward in a pool being saved.
///
/// [id] is absent for a reward the parent added on this device — the server
/// creates it — and present for one that exists, which the server updates.
@JsonSerializable(createFactory: false)
final class RewardPoolItemRequestDto extends BaseRequest {
  const RewardPoolItemRequestDto({
    required this.name,
    required this.category,
    required this.cost,
    this.id,
  });

  final String? id;

  final String name;

  final String category;

  final int cost;

  @override
  Map<String, dynamic> toJson() => _$RewardPoolItemRequestDtoToJson(this);
}
