import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_entity.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/points/rules/points_rules.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_category_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_kind_enum.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_repeat_enum.dart';
import 'package:lgs_reward_hunt/domain/task/rules/draft_rules.dart';
import 'package:lgs_reward_hunt/domain/task/rules/task_plan_rules.dart';

/// One recurring line of the parent's plan: what, when, how long, how often.
///
/// An entity, because the parent edits it in place — the row that was opened
/// is the row that changes — and it keeps its [id] through every edit. A task
/// the parent has just added has a draft id (`DraftRules.idPrefix`)
/// until the server gives it one.
///
/// [create] refuses what no edit on the setup page can produce but a payload
/// could: a [category] from the other [kind], points or a duration outside
/// `PointsRules`, a [startMinute] outside the day. The [topic] may be blank
/// while the parent is still typing it; a plan with a blank topic is refused
/// when it is saved, by `TaskPlanValueObject.create`.
///
/// The `with…` methods are the edits the page makes, and each keeps the
/// invariants: [withKind] moves the category into the new kind's list and the
/// duration onto one it offers, [withPoints] clamps to the economy's bounds.
/// [startHour] and [startMinuteOfHour] split the start for a clock face.
final class TaskTemplateEntity extends BaseEntity {
  const TaskTemplateEntity._({
    required this.id,
    required this.kind,
    required this.category,
    required this.topic,
    required this.startMinute,
    required this.durationMinutes,
    required this.points,
    required this.repeat,
  });

  @override
  final String id;

  final TaskKindEnum kind;

  final TaskCategoryEnum category;

  final String topic;

  final int startMinute;

  final int durationMinutes;

  final int points;

  final TaskRepeatEnum repeat;

  static Either<Failure, TaskTemplateEntity> create({
    required String id,
    required TaskKindEnum kind,
    required TaskCategoryEnum category,
    required String topic,
    required int startMinute,
    required int durationMinutes,
    required int points,
    required TaskRepeatEnum repeat,
  }) {
    if (category.kind != kind) {
      return const Left(
        ValidationFailure(FailureMessageKey.taskCategoryInvalid),
      );
    }
    if (startMinute < ValueConstants.zero ||
        startMinute >= TaskPlanRules.minutesPerDay) {
      return const Left(ValidationFailure(FailureMessageKey.taskTimeInvalid));
    }
    if (points < PointsRules.minTaskPoints ||
        points > PointsRules.maxTaskPoints) {
      return const Left(ValidationFailure(FailureMessageKey.taskPointsInvalid));
    }
    if (durationMinutes < PointsRules.minTaskMinutes ||
        durationMinutes > PointsRules.maxTaskMinutes) {
      return const Left(
        ValidationFailure(FailureMessageKey.taskDurationInvalid),
      );
    }
    return Right(
      TaskTemplateEntity._(
        id: id,
        kind: kind,
        category: category,
        topic: topic,
        startMinute: startMinute,
        durationMinutes: durationMinutes,
        points: points,
        repeat: repeat,
      ),
    );
  }

  static TaskTemplateEntity draft(String id) => TaskTemplateEntity._(
    id: id,
    kind: TaskKindEnum.lesson,
    category: TaskCategoryEnum.of(TaskKindEnum.lesson).first,
    topic: CharConstants.empty,
    startMinute: TaskPlanRules.newStartMinute,
    durationMinutes: TaskPlanRules.newDurationMinutes,
    points: TaskPlanRules.newPoints,
    repeat: TaskRepeatEnum.weekdays,
  );

  bool get isDraft => id.startsWith(DraftRules.idPrefix);

  bool get hasTopic => topic.trim().isNotEmpty;

  int get startHour => startMinute ~/ TaskPlanRules.minutesPerHour;

  int get startMinuteOfHour => startMinute % TaskPlanRules.minutesPerHour;

  TaskTemplateEntity withKind(TaskKindEnum value) => _copy(
    kind: value,
    category: category.kind == value
        ? category
        : TaskCategoryEnum.of(value).first,
    durationMinutes: value.minuteOptions.contains(durationMinutes)
        ? durationMinutes
        : value.minuteOptions.first,
  );

  TaskTemplateEntity withCategory(TaskCategoryEnum value) =>
      value.kind == kind ? _copy(category: value) : this;

  TaskTemplateEntity withTopic(String value) => _copy(topic: value);

  TaskTemplateEntity withStartMinute(int value) =>
      value < ValueConstants.zero || value >= TaskPlanRules.minutesPerDay
      ? this
      : _copy(startMinute: value);

  TaskTemplateEntity withDuration(int value) =>
      kind.minuteOptions.contains(value) ? _copy(durationMinutes: value) : this;

  TaskTemplateEntity withPoints(int value) => _copy(
    points: value
        .clamp(PointsRules.minTaskPoints, PointsRules.maxTaskPoints)
        .toInt(),
  );

  TaskTemplateEntity withRepeat(TaskRepeatEnum value) => _copy(repeat: value);

  TaskTemplateEntity _copy({
    TaskKindEnum? kind,
    TaskCategoryEnum? category,
    String? topic,
    int? startMinute,
    int? durationMinutes,
    int? points,
    TaskRepeatEnum? repeat,
  }) => TaskTemplateEntity._(
    id: id,
    kind: kind ?? this.kind,
    category: category ?? this.category,
    topic: topic ?? this.topic,
    startMinute: startMinute ?? this.startMinute,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    points: points ?? this.points,
    repeat: repeat ?? this.repeat,
  );
}
