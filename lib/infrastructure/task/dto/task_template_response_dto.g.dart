// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_template_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskTemplateResponseDto _$TaskTemplateResponseDtoFromJson(
  Map<String, dynamic> json,
) => TaskTemplateResponseDto(
  id: json['id'] as String,
  kind: json['kind'] as String,
  category: json['category'] as String,
  topic: json['topic'] as String,
  startMinute: (json['startMinute'] as num).toInt(),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  repeat: json['repeat'] as String,
);

Map<String, dynamic> _$TaskTemplateResponseDtoToJson(
  TaskTemplateResponseDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'category': instance.category,
  'topic': instance.topic,
  'startMinute': instance.startMinute,
  'durationMinutes': instance.durationMinutes,
  'points': instance.points,
  'repeat': instance.repeat,
};
