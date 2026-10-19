import 'package:lgs_reward_hunt/core/base/base_read_model.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/household_read_model.dart';
import 'package:lgs_reward_hunt/domain/parent/rules/parent_rules.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_draft_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';

/// Everything the parent's side shows, for the child this device is on.
///
/// A snapshot: [household] is the parent, their children and the faces;
/// [activeChild] the child this device opens on, with their [balance] and
/// [streakDays]; [pending] the household's requests waiting on a decision,
/// oldest first; [rewards] the parent's pool; [weekTasks] the active child's
/// tasks for `ParentRules.dayStripDays` days from [today]; [examDate] the end
/// a repeating task can run to; [presets] the suggested rewards a parent can add
/// with one tap.
///
/// [days] is the strip of days a parent plans from, [tasksOn] a day's tasks,
/// [todayDone] and [todayTotal] the line on the child's card, [openRewards]
/// how many rewards are switched on, and [childOf] whose a request is.
final class ParentDashboardReadModel extends BaseReadModel {
  const ParentDashboardReadModel({
    required this.household,
    required this.activeChild,
    required this.balance,
    required this.streakDays,
    required this.pending,
    required this.rewards,
    required this.weekTasks,
    required this.today,
    required this.examDate,
    required this.presets,
  });

  final HouseholdReadModel household;

  final ChildEntity activeChild;

  final int balance;

  final int streakDays;

  final List<RedemptionEntity> pending;

  final List<RewardEntity> rewards;

  final List<TaskEntity> weekTasks;

  final DateTime today;

  final DateTime examDate;

  final List<RewardDraftEntity> presets;

  List<DateTime> get days => <DateTime>[
    for (int offset = 0; offset < ParentRules.dayStripDays; offset++)
      DateTime(today.year, today.month, today.day + offset),
  ];

  List<TaskEntity> tasksOn(DateTime day) => weekTasks
      .where(
        (TaskEntity task) =>
            task.scheduledAt.year == day.year &&
            task.scheduledAt.month == day.month &&
            task.scheduledAt.day == day.day,
      )
      .toList();

  int get todayTotal => tasksOn(today).length;

  int get todayDone =>
      tasksOn(today).where((TaskEntity task) => task.isCompleted).length;

  int get openRewards =>
      rewards.where((RewardEntity reward) => reward.isActive).length;

  ChildEntity? childOf(RedemptionEntity request) {
    for (final ChildEntity child in household.children) {
      if (child.id == request.childId) return child;
    }
    return null;
  }

  bool get hasSeveralChildren => household.children.length > ValueConstants.one;

  @override
  List<Object?> get props => <Object?>[
    household,
    activeChild,
    balance,
    streakDays,
    pending,
    rewards,
    weekTasks,
    today,
    examDate,
    presets,
  ];
}
