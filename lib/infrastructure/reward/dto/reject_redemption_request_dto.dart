import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'reject_redemption_request_dto.g.dart';

/// What a parent sends when turning a request down.
///
/// The note is optional in the type and encouraged in the interface: a refusal
/// with a reason is a conversation, one without is a wall.
@JsonSerializable(createFactory: false)
final class RejectRedemptionRequestDto extends BaseRequest {
  const RejectRedemptionRequestDto({this.note});

  final String? note;

  @override
  Map<String, dynamic> toJson() => _$RejectRedemptionRequestDtoToJson(this);
}
