import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/account/dto/parent_response_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_response.dart';

part 'platform_sign_in_response_dto.g.dart';

/// The account a platform sign-in opened or found, and which of the two.
@JsonSerializable(explicitToJson: true)
final class PlatformSignInResponseDto extends BaseResponse {
  const PlatformSignInResponseDto({
    required this.parent,
    required this.isNewAccount,
  });

  factory PlatformSignInResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PlatformSignInResponseDtoFromJson(json);

  final ParentResponseDto parent;

  final bool isNewAccount;

  @override
  Map<String, dynamic> toJson() => _$PlatformSignInResponseDtoToJson(this);
}
