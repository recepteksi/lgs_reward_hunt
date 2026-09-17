// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarResponseDto _$AvatarResponseDtoFromJson(Map<String, dynamic> json) =>
    AvatarResponseDto(
      id: json['id'] as String,
      name: json['name'] as String,
      style: json['style'] as String,
      gender: json['gender'] as String?,
      skin: json['skin'] as String,
      hair: json['hair'] as String,
      shirt: json['shirt'] as String,
      background: json['background'] as String,
      accessory: json['accessory'] as String?,
    );

Map<String, dynamic> _$AvatarResponseDtoToJson(AvatarResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'style': instance.style,
      'gender': instance.gender,
      'skin': instance.skin,
      'hair': instance.hair,
      'shirt': instance.shirt,
      'background': instance.background,
      'accessory': instance.accessory,
    };
