import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';
import 'package:lgs_reward_hunt/infrastructure/reward/dto/reward_pool_item_request_dto.dart';

part 'save_reward_pool_request_dto.g.dart';

/// A whole reward pool, sent to become the parent's active rewards.
@JsonSerializable(createFactory: false, explicitToJson: true)
final class SaveRewardPoolRequestDto extends BaseRequest {
  const SaveRewardPoolRequestDto({required this.rewards});

  final List<RewardPoolItemRequestDto> rewards;

  @override
  Map<String, dynamic> toJson() => _$SaveRewardPoolRequestDtoToJson(this);
}
