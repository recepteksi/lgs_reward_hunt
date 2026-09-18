import 'package:lgs_reward_hunt/domain/task/enums/task_kind_enum.dart';

/// What a task is about: an exam subject, or a named chore.
///
/// Fixed rather than free text: a parent typing the same subject three ways
/// produces three subjects in every report the child ever sees, and no grouping
/// survives it. The list is the design's — the lessons a parent plans around
/// the LGS, [reading] and a [practiceExam] among them, and the chores the setup
/// step offers.
///
/// [kind] is which of the two lists a category belongs to, and [of] is that
/// list, in the order a parent is shown it. A task whose category does not
/// match its kind is refused by `TaskTemplateEntity.create`.
///
/// The colour and the words each one shows in are presentation's business —
/// this enum names the category and nothing else.
enum TaskCategoryEnum {
  math(TaskKindEnum.lesson),
  turkish(TaskKindEnum.lesson),
  science(TaskKindEnum.lesson),
  history(TaskKindEnum.lesson),
  english(TaskKindEnum.lesson),
  reading(TaskKindEnum.lesson),
  practiceExam(TaskKindEnum.lesson),
  brushTeeth(TaskKindEnum.chore),
  tidyRoom(TaskKindEnum.chore),
  dishes(TaskKindEnum.chore),
  trash(TaskKindEnum.chore),
  laundry(TaskKindEnum.chore),
  drinkWater(TaskKindEnum.chore),
  exercise(TaskKindEnum.chore),
  earlyBed(TaskKindEnum.chore),
  screenFree(TaskKindEnum.chore);

  const TaskCategoryEnum(this.kind);

  final TaskKindEnum kind;

  static List<TaskCategoryEnum> of(TaskKindEnum kind) => values
      .where((TaskCategoryEnum category) => category.kind == kind)
      .toList();

  static TaskCategoryEnum? fromName(String? name) {
    for (final TaskCategoryEnum category in values) {
      if (category.name == name) return category;
    }
    return null;
  }
}
