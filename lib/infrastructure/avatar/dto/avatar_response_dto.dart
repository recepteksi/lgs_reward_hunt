import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_response.dart';

part 'avatar_response_dto.g.dart';

/// One face from the catalogue, as the server sends it.
///
/// The colours arrive as `#RRGGBB` strings, which is what the wire speaks; the
/// repository turns them into ARGB ints. Keeping the raw strings on the DTO is
/// the point of the type — a colour that arrives malformed fails where it is
/// read, not where it is painted. [gender] is the catalogue tab the face is
/// filed under, as a word the domain enum parses.
@JsonSerializable()
final class AvatarResponseDto extends BaseResponse {
  const AvatarResponseDto({
    required this.id,
    required this.name,
    required this.style,
    this.gender,
    required this.skin,
    required this.hair,
    required this.shirt,
    required this.background,
    this.accessory,
  });

  factory AvatarResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AvatarResponseDtoFromJson(json);

  final String id;

  final String name;

  final String style;

  final String? gender;

  final String skin;

  final String hair;

  final String shirt;

  final String background;

  final String? accessory;

  @override
  Map<String, dynamic> toJson() => _$AvatarResponseDtoToJson(this);
}
