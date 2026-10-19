import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'task_template_request_dto.g.dart';

/// One line of a task plan, as it is sent to be saved.
///
/// [id] is absent for a line the parent added on this device — the server
/// gives it one — and present for a line that already has one, so a re-saved
/// plan keeps its ids.
@JsonSerializable(createFactory: false)
final class TaskTemplateRequestDto extends BaseRequest {
  const TaskTemplateRequestDto({
    required this.kind,
    required this.category,
    required this.topic,
    required this.startMinute,
    required this.durationMinutes,
    required this.points,
    required this.repeat,
    this.id,
  });

  final String? id;

  final String kind;

  final String category;

  final String topic;

  final int startMinute;

  final int durationMinutes;

  final int points;

  final String repeat;

  @override
  Map<String, dynamic> toJson() => _$TaskTemplateRequestDtoToJson(this);
}
