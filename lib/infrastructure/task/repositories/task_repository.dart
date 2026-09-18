import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';
import 'package:lgs_reward_hunt/domain/task/interfaces/task_repository_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/network/api_paths.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/network/failure_from_dio.dart';
import 'package:lgs_reward_hunt/infrastructure/task/dto/create_task_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/task/dto/task_response_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/task/dto/task_series_request_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/task/dto/update_task_request_dto.dart';

/// The day's plan, over HTTP.
///
/// [tasksForDay] sends the day as a plain ISO date rather than a timestamp:
/// "the tasks for the 14th" is a question about a calendar day, and a
/// timestamp drags the device's timezone into an answer that should not depend
/// on it.
///
/// A list is parsed strictly — one malformed row fails the whole call rather
/// than being skipped. A silently shortened list is a day that looks finished
/// when it is not, and the child is the one who finds out.
@LazySingleton(as: TaskRepositoryInterface)
final class TaskRepository implements TaskRepositoryInterface {
  const TaskRepository(this._client);

  final DioClient _client;

  @override
  Future<Either<Failure, List<TaskEntity>>> tasksForDay({
    required String childId,
    required DateTime day,
  }) async {
    try {
      final response = await _client.dio.get<List<dynamic>>(
        ApiPaths.tasksOfChild(childId),
        queryParameters: <String, Object?>{
          ApiPaths.dayQuery: _dayParameter(day),
        },
      );
      final tasks = <TaskEntity>[];
      for (final row in response.data!) {
        final parsed = TaskResponseDto.fromJson(
          Map<String, dynamic>.from(row as Map),
        ).toEntity();
        if (parsed.isLeft) return Left(parsed.left);
        tasks.add(parsed.right);
      }
      tasks.sort(
        (TaskEntity a, TaskEntity b) => a.scheduledAt.compareTo(b.scheduledAt),
      );
      return Right(tasks);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> tasksBetween({
    required String childId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _client.dio.get<List<dynamic>>(
        ApiPaths.tasksOfChild(childId),
        queryParameters: <String, Object?>{
          ApiPaths.fromQuery: _dayParameter(from),
          ApiPaths.toQuery: _dayParameter(to),
        },
      );
      final tasks = <TaskEntity>[];
      for (final row in response.data!) {
        final parsed = TaskResponseDto.fromJson(
          Map<String, dynamic>.from(row as Map),
        ).toEntity();
        if (parsed.isLeft) return Left(parsed.left);
        tasks.add(parsed.right);
      }
      tasks.sort(
        (TaskEntity a, TaskEntity b) => a.scheduledAt.compareTo(b.scheduledAt),
      );
      return Right(tasks);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask({
    required String childId,
    required String title,
    required TaskCategoryEnum category,
    required DateTime scheduledAt,
    required int durationMinutes,
    required int points,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.tasksOfChild(childId),
        data: CreateTaskRequestDto(
          title: title,
          category: category.name,
          scheduledAt: scheduledAt.toIso8601String(),
          durationMinutes: durationMinutes,
          points: points,
        ).toJson(),
      );
      return TaskResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> completeTask({
    required String taskId,
  }) async {
    try {
      final response = await _client.dio.post<Map<String, dynamic>>(
        ApiPaths.completeTask(taskId),
      );
      return TaskResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> addSeries({
    required String childId,
    required TaskTemplateEntity template,
    required DateTime from,
    required DateTime until,
  }) async {
    try {
      final response = await _client.dio.post<List<dynamic>>(
        ApiPaths.taskSeriesOfChild(childId),
        data: TaskSeriesRequestDto(
          kind: template.kind.name,
          category: template.category.name,
          topic: template.topic.trim(),
          startMinute: template.startMinute,
          durationMinutes: template.durationMinutes,
          points: template.points,
          repeat: template.repeat.name,
          from: _dayParameter(from),
          until: _dayParameter(until),
        ).toJson(),
      );
      final tasks = <TaskEntity>[];
      for (final row in response.data!) {
        final parsed = TaskResponseDto.fromJson(
          Map<String, dynamic>.from(row as Map),
        ).toEntity();
        if (parsed.isLeft) return Left(parsed.left);
        tasks.add(parsed.right);
      }
      return Right(tasks);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask({
    required String taskId,
    required TaskTemplateEntity template,
    required DateTime day,
  }) async {
    try {
      final response = await _client.dio.put<Map<String, dynamic>>(
        ApiPaths.task(taskId),
        data: UpdateTaskRequestDto(
          title: template.topic.trim(),
          category: template.category.name,
          scheduledAt: DateTime(
            day.year,
            day.month,
            day.day,
          ).add(Duration(minutes: template.startMinute)).toIso8601String(),
          durationMinutes: template.durationMinutes,
          points: template.points,
        ).toJson(),
      );
      return TaskResponseDto.fromJson(response.data!).toEntity();
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask({required String taskId}) async {
    try {
      await _client.dio.delete<void>(ApiPaths.task(taskId));
      return const Right(null);
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }
}

String _dayParameter(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';
