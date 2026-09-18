// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentResponseDto _$ParentResponseDtoFromJson(Map<String, dynamic> json) =>
    ParentResponseDto(
      id: json['id'] as String,
      name: json['name'] as String,
      linkCode: json['linkCode'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$ParentResponseDtoToJson(ParentResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'linkCode': instance.linkCode,
      'email': instance.email,
    };
