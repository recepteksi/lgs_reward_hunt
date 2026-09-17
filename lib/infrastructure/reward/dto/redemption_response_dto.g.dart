// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redemption_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedemptionResponseDto _$RedemptionResponseDtoFromJson(
  Map<String, dynamic> json,
) => RedemptionResponseDto(
  id: json['id'] as String,
  childId: json['childId'] as String,
  rewardId: json['rewardId'] as String,
  rewardName: json['rewardName'] as String,
  costAtRequest: (json['costAtRequest'] as num).toInt(),
  requestedAt: json['requestedAt'] as String,
  status: json['status'] as String?,
  decidedAt: json['decidedAt'] as String?,
  parentNote: json['parentNote'] as String?,
);

Map<String, dynamic> _$RedemptionResponseDtoToJson(
  RedemptionResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'childId': instance.childId,
  'rewardId': instance.rewardId,
  'rewardName': instance.rewardName,
  'costAtRequest': instance.costAtRequest,
  'requestedAt': instance.requestedAt,
  'status': instance.status,
  'decidedAt': instance.decidedAt,
  'parentNote': instance.parentNote,
};
