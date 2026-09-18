// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardResponseDto _$RewardResponseDtoFromJson(Map<String, dynamic> json) =>
    RewardResponseDto(
      id: json['id'] as String,
      parentId: json['parentId'] as String,
      name: json['name'] as String,
      cost: (json['cost'] as num).toInt(),
      category: json['category'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$RewardResponseDtoToJson(RewardResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'name': instance.name,
      'category': instance.category,
      'cost': instance.cost,
      'isActive': instance.isActive,
    };
