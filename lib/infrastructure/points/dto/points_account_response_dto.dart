import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_response.dart';
import 'package:lgs_reward_hunt/infrastructure/points/dto/points_entry_response_dto.dart';

part 'points_account_response_dto.g.dart';

/// A child's whole ledger, as the server sends it.
///
/// The envelope exists on the wire and so it exists here: reading
/// `response.data!['entries']` by hand is the kind of thing that works until
/// the day the server adds a second key.
@JsonSerializable(explicitToJson: true)
final class PointsAccountResponseDto extends BaseResponse {
  const PointsAccountResponseDto({required this.entries});

  factory PointsAccountResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PointsAccountResponseDtoFromJson(json);

  final List<PointsEntryResponseDto> entries;

  @override
  Map<String, dynamic> toJson() => _$PointsAccountResponseDtoToJson(this);
}
