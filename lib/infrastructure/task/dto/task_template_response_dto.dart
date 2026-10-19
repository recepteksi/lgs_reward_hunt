import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_response.dart';

part 'task_template_response_dto.g.dart';

/// One line of a task plan, as the server sends it.
///
/// The enums arrive as their names and the start as minutes after midnight;
/// `TaskPlanRepository` turns the row into a `TaskTemplateEntity` and refuses
/// one whose names it does not know.
@JsonSerializable()
final class TaskTemplateResponseDto extends BaseResponse {
  const TaskTemplateResponseDto({
    required this.id,
    required this.kind,
    required this.category,
    required this.topic,
    required this.startMinute,
    required this.durationMinutes,
    required this.points,
    required this.repeat,
  });

  factory TaskTemplateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TaskTemplateResponseDtoFromJson(json);

  final String id;

  final String kind;

  final String category;

  final String topic;

  final int startMinute;

  final int durationMinutes;

  final int points;

  final String repeat;

  @override
  Map<String, dynamic> toJson() => _$TaskTemplateResponseDtoToJson(this);
}
