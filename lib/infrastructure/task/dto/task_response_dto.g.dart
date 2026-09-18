// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskResponseDto _$TaskResponseDtoFromJson(Map<String, dynamic> json) =>
    TaskResponseDto(
      id: json['id'] as String,
      childId: json['childId'] as String,
      title: json['title'] as String,
      category: json['category'] as String?,
      scheduledAt: json['scheduledAt'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      points: (json['points'] as num).toInt(),
      completedAt: json['completedAt'] as String?,
    );

Map<String, dynamic> _$TaskResponseDtoToJson(TaskResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childId': instance.childId,
      'title': instance.title,
      'category': instance.category,
      'scheduledAt': instance.scheduledAt,
      'durationMinutes': instance.durationMinutes,
      'points': instance.points,
      'completedAt': instance.completedAt,
    };
