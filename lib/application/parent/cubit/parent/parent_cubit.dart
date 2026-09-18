import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/auth/use_cases/sign_out_use_case.dart';
import 'package:lgs_reward_hunt/application/parent/use_cases/load_parent_dashboard_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/add_reward_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/decide_redemption_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/remove_reward_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/update_reward_use_case.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/choose_device_child_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/add_task_series_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/delete_task_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/update_task_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/parent/enums/parent_notice_enum.dart';
import 'package:lgs_reward_hunt/domain/parent/read_models/parent_dashboard_read_model.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/rules/reward_pool_rules.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_series_end_enum.dart';

part 'parent_state.dart';

/// The parent's side: approvals, the week's tasks, the reward pool, and which
/// child the device is on.
///
/// Every action is the same shape: say it is working, ask the use case, and on
/// success read the dashboard again — an approval moves a balance, a new task
/// changes a day's count, a switched child changes everything, and the server
/// is what knows by how much. A refusal leaves the dashboard as it was and
/// carries the reason in [ParentActionFailed]; one worth confirming ends in
/// [ParentDone] with its [ParentNoticeEnum], which the page shows once. Which tab and which day are
/// showing are the page's, not this.
///
/// [signOut] works in any state, including [ParentFailed], because it needs
/// nothing from the server. It ends in [ParentSignedOut], and the page then
/// leaves for the intro. A session that could not be cleared stays on the
/// page with the failure, because leaving would reopen signed in next launch.
/// A second tap while it runs does nothing.
///
/// [clock] is today's moment, injected so a test can stand on any day.
@injectable
final class ParentCubit extends Cubit<ParentState> {
  ParentCubit(
    this._load,
    this._decide,
    this._chooseChild,
    this._addTasks,
    this._updateTask,
    this._deleteTask,
    this._addReward,
    this._updateReward,
    this._removeReward,
    this._signOut,
  ) : clock = DateTime.now,
      super(const ParentLoading());

  final LoadParentDashboardUseCase _load;

  final DecideRedemptionUseCase _decide;

  final ChooseDeviceChildUseCase _chooseChild;

  final AddTaskSeriesUseCase _addTasks;

  final UpdateTaskUseCase _updateTask;

  final DeleteTaskUseCase _deleteTask;

  final AddRewardUseCase _addReward;

  final UpdateRewardUseCase _updateReward;

  final RemoveRewardUseCase _removeReward;

  final SignOutUseCase _signOut;

  DateTime Function() clock;

  bool _signingOut = false;

  Future<void> load() async {
    emit(const ParentLoading());

    final result = await _load(now: clock());
    if (isClosed) return;

    emit(switch (result) {
      Left(:final value) => ParentFailed(value),
      Right(:final value) => ParentReady(value),
    });
  }

  Future<void> decide(String redemptionId, {required bool approve}) => _act(
    (_) => _decide(redemptionId: redemptionId, approve: approve),
    notice: approve ? ParentNoticeEnum.approved : ParentNoticeEnum.rejected,
  );

  Future<void> chooseChild(String childId) =>
      _act((_) => _chooseChild(childId));

  Future<void> addTask({
    required TaskTemplateEntity template,
    required DateTime day,
    required TaskSeriesEndEnum end,
  }) => _act(
    (ParentDashboardReadModel dashboard) => _addTasks(
      childId: dashboard.activeChild.id,
      template: template,
      from: day,
      end: end,
      examDate: dashboard.examDate,
    ),
    notice: ParentNoticeEnum.tasksAdded,
  );

  Future<void> updateTask({
    required String taskId,
    required TaskTemplateEntity template,
    required DateTime day,
  }) => _act(
    (_) => _updateTask(taskId: taskId, template: template, day: day),
    notice: ParentNoticeEnum.taskSaved,
  );

  Future<void> deleteTask(String taskId) =>
      _act((_) => _deleteTask(taskId), notice: ParentNoticeEnum.taskRemoved);

  Future<void> addReward({
    required String name,
    required RewardCategoryEnum category,
    required int cost,
  }) => _act(
    (ParentDashboardReadModel dashboard) => _addReward(
      parentId: dashboard.household.parent.id,
      name: name,
      category: category,
      cost: cost,
    ),
    notice: ParentNoticeEnum.rewardAdded,
  );

  Future<void> setRewardActive(RewardEntity reward, {required bool isActive}) =>
      _act((_) => _updateReward(rewardId: reward.id, isActive: isActive));

  Future<void> bumpCost(RewardEntity reward, {required bool up}) => _act(
    (_) => _updateReward(
      rewardId: reward.id,
      cost:
          (reward.cost +
                  (up ? RewardPoolRules.costStep : -RewardPoolRules.costStep))
              .clamp(RewardPoolRules.minCost, RewardPoolRules.maxCost)
              .toInt(),
    ),
  );

  Future<void> removeReward(String rewardId) =>
      _act((_) => _removeReward(rewardId));

  Future<void> signOut() async {
    if (_signingOut || state is ParentSignedOut) return;
    _signingOut = true;

    final result = await _signOut();
    _signingOut = false;
    if (isClosed) return;

    final ParentState current = state;
    emit(switch (result) {
      Right() => const ParentSignedOut(),
      Left(:final value) when current is ParentShowing => ParentActionFailed(
        current.dashboard,
        value,
      ),
      Left(:final value) => ParentFailed(value),
    });
  }

  Future<void> _act(
    Future<Either<Failure, Object?>> Function(
      ParentDashboardReadModel dashboard,
    )
    action, {
    ParentNoticeEnum? notice,
  }) async {
    final ParentState current = state;
    if (current is! ParentShowing || current is ParentWorking) return;

    emit(ParentWorking(current.dashboard));

    final result = await action(current.dashboard);
    if (isClosed) return;
    if (result.isLeft) {
      emit(ParentActionFailed(current.dashboard, result.left));
      return;
    }

    final reloaded = await _load(now: clock());
    if (isClosed) return;

    emit(switch (reloaded) {
      Left(:final value) => ParentActionFailed(current.dashboard, value),
      Right(:final value) =>
        notice == null ? ParentReady(value) : ParentDone(value, notice),
    });
  }
}
