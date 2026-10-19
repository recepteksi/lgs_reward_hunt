import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/core/validators/not_empty_list_validator.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_kind_enum.dart';
import 'package:lgs_reward_hunt/domain/task/rules/draft_rules.dart';
import 'package:lgs_reward_hunt/domain/task/validators/titled_templates_validator.dart';

/// The parent's whole task plan: the recurring lines a fortnight is built from.
///
/// A value object — two plans holding the same lines are the same plan — and
/// the thing the setup page edits and saves. The edits ([withNewTemplate],
/// [replacing], [without]) each answer a new plan rather than changing this
/// one, so a page holding the old one cannot see it move.
///
/// [create] is the save-time check (`NotEmptyListValidator`,
/// `TitledTemplatesValidator`): a plan with no lines, or with a line whose
/// topic is still blank, is refused — while editing, both are allowed, because
/// a parent deletes the last line before adding a new one and types a topic a
/// letter at a time.
///
/// [countOf] and [pointsOn] are the summary line over the list: how many
/// lessons and chores, and what the plan is worth on a given day — which uses
/// `TaskRepeatEnum.occursOn`, the same rule the backend writes the tasks with.
final class TaskPlanValueObject
    extends BaseValueObject<List<TaskTemplateEntity>> {
  const TaskPlanValueObject(super.value);

  static const TaskPlanValueObject empty = TaskPlanValueObject(
    <TaskTemplateEntity>[],
  );

  List<TaskTemplateEntity> get templates => value;

  static Either<Failure, TaskPlanValueObject> create(
    List<TaskTemplateEntity> templates,
  ) {
    final TaskPlanValueObject checked = TaskPlanValueObject(
      List<TaskTemplateEntity>.unmodifiable(templates),
    );
    return checked.valueObject.map((_) => checked);
  }

  bool get isEmpty => templates.isEmpty;

  int countOf(TaskKindEnum kind) => templates
      .where((TaskTemplateEntity template) => template.kind == kind)
      .length;

  int pointsOn(DateTime day, {required DateTime from}) => templates
      .where(
        (TaskTemplateEntity template) =>
            template.repeat.occursOn(day, from: from),
      )
      .fold(
        ValueConstants.zero,
        (int sum, TaskTemplateEntity template) => sum + template.points,
      );

  TaskPlanValueObject withNewTemplate() {
    int number = templates.length;
    String id;
    do {
      number += ValueConstants.one;
      id = '${DraftRules.idPrefix}$number';
    } while (templates.any((TaskTemplateEntity t) => t.id == id));

    return TaskPlanValueObject(<TaskTemplateEntity>[
      ...templates,
      TaskTemplateEntity.draft(id),
    ]);
  }

  TaskPlanValueObject replacing(TaskTemplateEntity template) =>
      TaskPlanValueObject(<TaskTemplateEntity>[
        for (final TaskTemplateEntity current in templates)
          current.id == template.id ? template : current,
      ]);

  TaskPlanValueObject without(String templateId) =>
      TaskPlanValueObject(<TaskTemplateEntity>[
        for (final TaskTemplateEntity current in templates)
          if (current.id != templateId) current,
      ]);

  @override
  List<BaseValueValidator<List<TaskTemplateEntity>>> get validators =>
      const <BaseValueValidator<List<TaskTemplateEntity>>>[
        NotEmptyListValidator<TaskTemplateEntity>(
          FailureMessageKey.taskPlanEmpty,
        ),
        TitledTemplatesValidator(),
      ];
}
