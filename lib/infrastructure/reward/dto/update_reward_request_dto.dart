import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'update_reward_request_dto.g.dart';

/// A change to one reward in the pool: a new price, on or off, or both.
///
/// Fields left null are not sent, so a price change cannot switch a reward
/// off by accident.
@JsonSerializable(createFactory: false, includeIfNull: false)
final class UpdateRewardRequestDto extends BaseRequest {
  const UpdateRewardRequestDto({this.cost, this.isActive});

  final int? cost;

  final bool? isActive;

  @override
  Map<String, dynamic> toJson() => _$UpdateRewardRequestDtoToJson(this);
}
