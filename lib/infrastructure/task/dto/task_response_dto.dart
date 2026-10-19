import 'package:either_dart/either.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_response.dart';

part 'task_response_dto.g.dart';

/// A task, as the server sends one.
///
/// Dates arrive as ISO strings and stay strings here: parsing them is the
/// repository's job, and a DTO that parsed would be a DTO that could throw
/// while merely being read.
///
/// [toEntity] turns this row into its entity.
@JsonSerializable()
final class TaskResponseDto extends BaseResponse {
  const TaskResponseDto({
    required this.id,
    required this.childId,
    required this.title,
    required this.category,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.points,
    this.completedAt,
  });

  factory TaskResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TaskResponseDtoFromJson(json);

  final String id;

  final String childId;

  final String title;

  final String? category;

  final String scheduledAt;

  final int durationMinutes;

  final int points;

  final String? completedAt;

  @override
  Map<String, dynamic> toJson() => _$TaskResponseDtoToJson(this);

  Either<Failure, TaskEntity> toEntity() {
    TaskCategoryEnum? known;
    for (final TaskCategoryEnum value in TaskCategoryEnum.values) {
      if (value.name == category) known = value;
    }

    if (known == null) {
      return const Left(UnknownFailure(FailureMessageKey.unexpectedResponse));
    }

    return TaskEntity.create(
      id: id,
      childId: childId,
      title: title,
      category: known,
      scheduledAt: DateTime.parse(scheduledAt),
      durationMinutes: durationMinutes,
      points: points,
      completedAt: completedAt == null ? null : DateTime.parse(completedAt!),
    );
  }
}
