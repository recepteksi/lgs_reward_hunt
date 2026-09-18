// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_account_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointsAccountResponseDto _$PointsAccountResponseDtoFromJson(
  Map<String, dynamic> json,
) => PointsAccountResponseDto(
  entries: (json['entries'] as List<dynamic>)
      .map((e) => PointsEntryResponseDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PointsAccountResponseDtoToJson(
  PointsAccountResponseDto instance,
) => <String, dynamic>{
  'entries': instance.entries.map((e) => e.toJson()).toList(),
};
