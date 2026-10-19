import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_response.dart';

part 'parent_pin_response_dto.g.dart';

/// The answer to "is this the right PIN?".
///
/// A flag rather than a status code, because a wrong PIN is an ordinary answer
/// on that screen and not a failure — the repository reads [ok] and hands back
/// a `bool`, and nothing above it has to know an HTTP status.
@JsonSerializable()
final class ParentPinResponseDto extends BaseResponse {
  const ParentPinResponseDto({required this.ok});

  factory ParentPinResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ParentPinResponseDtoFromJson(json);

  final bool ok;

  @override
  Map<String, dynamic> toJson() => _$ParentPinResponseDtoToJson(this);
}
