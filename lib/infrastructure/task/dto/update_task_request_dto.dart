import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'update_task_request_dto.g.dart';

/// The new fields of an unfinished task a parent edits.
@JsonSerializable(createFactory: false)
final class UpdateTaskRequestDto extends BaseRequest {
  const UpdateTaskRequestDto({
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
  Map<String, dynamic> toJson() => _$UpdateTaskRequestDtoToJson(this);
}
