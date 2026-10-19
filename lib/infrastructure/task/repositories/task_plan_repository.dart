import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_kind_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_repeat_enum.dart';
import 'package:lgs_reward_hunt/domain/task/interfaces/task_plan_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/task/value_objects/task_plan_value_object.dart';
import 'package:lgs_reward_hunt/infrastructure/network/api_paths.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/network/failure_from_dio.dart';
import 'package:lgs_reward_hunt/infrastructure/task/dto/save_task_plan_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/task/dto/task_template_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/task/dto/task_template_response_dto.dart';

/// The parent's task plan, over HTTP.
///
/// Every answer is a list of template rows, parsed strictly: one row the
/// domain refuses fails the whole plan, because a plan silently missing a line
/// is a fortnight of tasks the parent did not agree to. A draft id is not sent
/// — the server gives the line its own.
@LazySingleton(as: TaskPlanRepositoryInterface)
final class TaskPlanRepository implements TaskPlanRepositoryInterface {
  const TaskPlanRepository(this._client);

  final DioClient _client;

  @override
  Future<Either<Failure, TaskPlanValueObject>> standardPlan() =>
      _read(ApiPaths.standardTaskPlan);

  @override
  Future<Either<Failure, TaskPlanValueObject>> planOf(String parentId) =>
      _read(ApiPaths.taskPlanOfParent(parentId));

  @override
  Future<Either<Failure, TaskPlanValueObject>> savePlan({
    required String parentId,
    required TaskPlanValueObject plan,
  }) async {
    try {
      final response = await _client.dio.put<List<dynamic>>(
        ApiPaths.taskPlanOfParent(parentId),
        data: SaveTaskPlanRequestDto(
          templates: <TaskTemplateRequestDto>[
            for (final TaskTemplateEntity template in plan.templates)
              TaskTemplateRequestDto(
                id: template.isDraft ? null : template.id,
                kind: template.kind.name,
                category: template.category.name,
                topic: template.topic.trim(),
                startMinute: template.startMinute,
                durationMinutes: template.durationMinutes,
                points: template.points,
                repeat: template.repeat.name,
              ),
          ],
        ).toJson(),
      );
      return _planFrom(response.data!);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  Future<Either<Failure, TaskPlanValueObject>> _read(String path) async {
    try {
      final response = await _client.dio.get<List<dynamic>>(path);
      return _planFrom(response.data!);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  Either<Failure, TaskPlanValueObject> _planFrom(List<dynamic> rows) {
    final List<TaskTemplateEntity> templates = <TaskTemplateEntity>[];
    for (final dynamic row in rows) {
      final template = _templateFrom(
        TaskTemplateResponseDto.fromJson(Map<String, dynamic>.from(row as Map)),
      );
      if (template.isLeft) return Left(template.left);
      templates.add(template.right);
    }
    return Right(TaskPlanValueObject(templates));
  }

  Either<Failure, TaskTemplateEntity> _templateFrom(
    TaskTemplateResponseDto dto,
  ) {
    final TaskKindEnum? kind = _kindFrom(dto.kind);
    final TaskCategoryEnum? category = TaskCategoryEnum.fromName(dto.category);
    final TaskRepeatEnum? repeat = TaskRepeatEnum.fromName(dto.repeat);
    if (kind == null || category == null || repeat == null) {
      return const Left(UnknownFailure(FailureMessageKey.unexpectedResponse));
    }

    return TaskTemplateEntity.create(
      id: dto.id,
      kind: kind,
      category: category,
      topic: dto.topic,
      startMinute: dto.startMinute,
      durationMinutes: dto.durationMinutes,
      points: dto.points,
      repeat: repeat,
    );
  }

  TaskKindEnum? _kindFrom(String name) {
    for (final TaskKindEnum kind in TaskKindEnum.values) {
      if (kind.name == name) return kind;
    }
    return null;
  }
}
