import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'redeem_request_dto.g.dart';

/// What a child sends to ask for a reward.
@JsonSerializable(createFactory: false)
final class RedeemRequestDto extends BaseRequest {
  const RedeemRequestDto({required this.rewardId});

  final String rewardId;

  @override
  Map<String, dynamic> toJson() => _$RedeemRequestDtoToJson(this);
}
