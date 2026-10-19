import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'create_reward_request_dto.g.dart';

/// What is sent to add a reward to the pool.
@JsonSerializable(createFactory: false)
final class CreateRewardRequestDto extends BaseRequest {
  const CreateRewardRequestDto({
    required this.name,
    required this.category,
    required this.cost,
  });

  final String name;

  final String category;

  final int cost;

  @override
  Map<String, dynamic> toJson() => _$CreateRewardRequestDtoToJson(this);
}
