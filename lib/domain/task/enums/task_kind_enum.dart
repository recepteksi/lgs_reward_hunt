import 'package:lgs_reward_hunt/domain/task/rules/task_plan_rules.dart';

/// The two kinds of thing a child is asked to do.
///
/// A [lesson] is study for the exam; a [chore] is a responsibility at home.
/// They share the points economy but not their shape: a chore is shorter and
/// has its own list of names, so the kind decides which categories a task may
/// carry and which lengths are offered. [minuteOptions] is that second rule.
enum TaskKindEnum {
  lesson,
  chore;

  List<int> get minuteOptions => switch (this) {
    TaskKindEnum.lesson => TaskPlanRules.lessonMinuteOptions,
    TaskKindEnum.chore => TaskPlanRules.choreMinuteOptions,
  };
}
