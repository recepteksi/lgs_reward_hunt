// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildResponseDto _$ChildResponseDtoFromJson(Map<String, dynamic> json) =>
    ChildResponseDto(
      id: json['id'] as String,
      parentId: json['parentId'] as String,
      name: json['name'] as String,
      gradeLevel: (json['gradeLevel'] as num).toInt(),
      avatarId: json['avatarId'] as String?,
    );

Map<String, dynamic> _$ChildResponseDtoToJson(ChildResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'name': instance.name,
      'gradeLevel': instance.gradeLevel,
      'avatarId': instance.avatarId,
    };
