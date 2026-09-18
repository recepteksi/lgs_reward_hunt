import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/load_task_plan_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/save_task_plan_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/value_objects/task_plan_value_object.dart';

part 'task_setup_state.dart';

/// The task setup step: the plan being edited, and saving it.
///
/// Unlike a text form, the plan IS application state: it is loaded, edited
/// line by line and saved as a whole, and the summary over the list is worked
/// out from it. So the edits come here — [add], [update], [remove] — and each
/// asks the plan for a new plan rather than computing one; the Cubit only
/// emits it. Which line is open is the page's business, not this.
///
/// [save] keeps the plan on screen while it waits and on a refusal, so a
/// parent whose topic was blank finds their plan intact with the reason under
/// it.
@injectable
final class TaskSetupCubit extends Cubit<TaskSetupState> {
  TaskSetupCubit(this._loadPlan, this._savePlan)
    : super(const TaskSetupLoading());

  final LoadTaskPlanUseCase _loadPlan;

  final SaveTaskPlanUseCase _savePlan;

  Future<void> load() async {
    emit(const TaskSetupLoading());

    final result = await _loadPlan();
    if (isClosed) return;

    emit(switch (result) {
      Left(:final value) => TaskSetupLoadFailed(value),
      Right(:final value) => TaskSetupEditing(value),
    });
  }

  void add() => _edit((TaskPlanValueObject plan) => plan.withNewTemplate());

  void update(TaskTemplateEntity template) =>
      _edit((TaskPlanValueObject plan) => plan.replacing(template));

  void remove(String templateId) =>
      _edit((TaskPlanValueObject plan) => plan.without(templateId));

  Future<void> save() async {
    final TaskPlanValueObject? plan = _plan;
    if (plan == null || state is TaskSetupSaving) return;

    emit(TaskSetupSaving(plan));

    final result = await _savePlan(plan);
    if (isClosed) return;

    emit(switch (result) {
      Left(:final value) => TaskSetupSaveFailed(plan, value),
      Right(:final value) => TaskSetupSaved(value),
    });
  }

  TaskPlanValueObject? get _plan => switch (state) {
    TaskSetupEditing(:final plan) ||
    TaskSetupSaving(:final plan) ||
    TaskSetupSaveFailed(:final plan) ||
    TaskSetupSaved(:final plan) => plan,
    TaskSetupLoading() || TaskSetupLoadFailed() => null,
  };

  void _edit(TaskPlanValueObject Function(TaskPlanValueObject plan) change) {
    final TaskSetupState current = state;
    if (current is! TaskSetupEditing && current is! TaskSetupSaveFailed) {
      return;
    }
    emit(TaskSetupEditing(change(_plan!)));
  }
}
