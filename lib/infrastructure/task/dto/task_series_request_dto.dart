import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'task_series_request_dto.g.dart';

/// A task a parent adds, with how often it comes back and between which days.
///
/// [from] and [until] are plain ISO dates; the server writes the task on every
/// day between them its [repeat] falls on.
@JsonSerializable(createFactory: false)
final class TaskSeriesRequestDto extends BaseRequest {
  const TaskSeriesRequestDto({
    required this.kind,
    required this.category,
    required this.topic,
    required this.startMinute,
    required this.durationMinutes,
    required this.points,
    required this.repeat,
    required this.from,
    required this.until,
  });

  final String kind;

  final String category;

  final String topic;

  final int startMinute;

  final int durationMinutes;

  final int points;

  final String repeat;

  final String from;

  final String until;

  @override
  Map<String, dynamic> toJson() => _$TaskSeriesRequestDtoToJson(this);
}
