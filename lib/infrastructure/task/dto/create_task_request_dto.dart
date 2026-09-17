import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'create_task_request_dto.g.dart';

/// What is sent to put a task on a child's day.
@JsonSerializable(createFactory: false)
final class CreateTaskRequestDto extends BaseRequest {
  const CreateTaskRequestDto({
    required this.title,
    required this.category,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.points,
  });

  final String title;

  final String category;

  final String scheduledAt;

  final int durationMinutes;

  final int points;

  @override
  Map<String, dynamic> toJson() => _$CreateTaskRequestDtoToJson(this);
}
