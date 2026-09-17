import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/load_reward_pool_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/save_reward_pool_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/load_task_plan_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_draft_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/value_objects/reward_pool_value_object.dart';
import 'package:lgs_reward_hunt/domain/task/value_objects/task_plan_value_object.dart';

part 'reward_setup_state.dart';

/// The reward setup step: the pool being edited, and saving it to end setup.
///
/// The same shape as the task setup step: the pool is application state, the
/// edits — [add], [update], [remove] — ask the pool for a new pool, and
/// [save] keeps the list on screen while it waits and after a refusal.
///
/// A saved pool also reads back the task plan saved one step earlier, so the
/// closing toast can count both. That read cannot undo a finished setup: if it
/// fails, the state carries no task count and the toast counts rewards only.
@injectable
final class RewardSetupCubit extends Cubit<RewardSetupState> {
  RewardSetupCubit(this._loadPool, this._savePool, this._loadPlan)
    : super(const RewardSetupLoading());

  final LoadRewardPoolUseCase _loadPool;

  final SaveRewardPoolUseCase _savePool;

  final LoadTaskPlanUseCase _loadPlan;

  Future<void> load() async {
    emit(const RewardSetupLoading());

    final result = await _loadPool();
    if (isClosed) return;

    emit(switch (result) {
      Left(:final value) => RewardSetupLoadFailed(value),
      Right(:final value) => RewardSetupEditing(value),
    });
  }

  void add() => _edit((RewardPoolValueObject pool) => pool.withNewDraft());

  void update(RewardDraftEntity reward) =>
      _edit((RewardPoolValueObject pool) => pool.replacing(reward));

  void remove(String rewardId) =>
      _edit((RewardPoolValueObject pool) => pool.without(rewardId));

  Future<void> save() async {
    final RewardPoolValueObject? pool = _pool;
    if (pool == null || state is RewardSetupSaving) return;

    emit(RewardSetupSaving(pool));

    final result = await _savePool(pool);
    if (isClosed) return;

    if (result case Left(:final value)) {
      emit(RewardSetupSaveFailed(pool, value));
      return;
    }

    final plan = await _loadPlan();
    if (isClosed) return;

    emit(
      RewardSetupSaved(
        result.right,
        taskCount: plan.fold(
          (Failure _) => null,
          (TaskPlanValueObject value) => value.templates.length,
        ),
      ),
    );
  }

  RewardPoolValueObject? get _pool => switch (state) {
    RewardSetupEditing(:final pool) ||
    RewardSetupSaving(:final pool) ||
    RewardSetupSaveFailed(:final pool) ||
    RewardSetupSaved(:final pool) => pool,
    RewardSetupLoading() || RewardSetupLoadFailed() => null,
  };

  void _edit(
    RewardPoolValueObject Function(RewardPoolValueObject pool) change,
  ) {
    final RewardSetupState current = state;
    if (current is! RewardSetupEditing && current is! RewardSetupSaveFailed) {
      return;
    }
    emit(RewardSetupEditing(change(_pool!)));
  }
}
