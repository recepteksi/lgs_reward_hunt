// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_entry_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointsEntryResponseDto _$PointsEntryResponseDtoFromJson(
  Map<String, dynamic> json,
) => PointsEntryResponseDto(
  id: json['id'] as String,
  childId: json['childId'] as String,
  amount: (json['amount'] as num).toInt(),
  occurredAt: json['occurredAt'] as String,
  reason: json['reason'] as String?,
  reference: json['reference'] as String?,
);

Map<String, dynamic> _$PointsEntryResponseDtoToJson(
  PointsEntryResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'childId': instance.childId,
  'amount': instance.amount,
  'occurredAt': instance.occurredAt,
  'reason': instance.reason,
  'reference': instance.reference,
};
