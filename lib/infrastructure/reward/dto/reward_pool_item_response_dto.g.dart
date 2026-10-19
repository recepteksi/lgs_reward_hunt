// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_pool_item_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardPoolItemResponseDto _$RewardPoolItemResponseDtoFromJson(
  Map<String, dynamic> json,
) => RewardPoolItemResponseDto(
  id: json['id'] as String,
  name: json['name'] as String,
  cost: (json['cost'] as num).toInt(),
  category: json['category'] as String?,
  isActive: json['isActive'] as bool?,
);

Map<String, dynamic> _$RewardPoolItemResponseDtoToJson(
  RewardPoolItemResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'cost': instance.cost,
  'isActive': instance.isActive,
};
