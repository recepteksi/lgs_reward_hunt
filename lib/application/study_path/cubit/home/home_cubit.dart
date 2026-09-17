import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/read_child_snapshot_use_case.dart';
import 'package:lgs_reward_hunt/application/study_path/use_cases/load_study_map_use_case.dart';
import 'package:lgs_reward_hunt/application/task/use_cases/complete_task_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_snapshot_read_model.dart';
import 'package:lgs_reward_hunt/domain/study_path/read_models/study_map_read_model.dart';

part 'home_state.dart';

/// The home page: the child's map, and ticking today's tasks on it.
///
/// [load] reads the map. [complete] ticks a task and then reads the map
/// again rather than patching the old one — completing the last task of a day
/// pays a bonus and moves the trail, and the server is the one that knows
/// both. While it waits the map stays on screen with the task marked busy; a
/// refusal comes back as [HomeCompleteFailed], still carrying the map.
///
/// [clock] is today's moment, injected so a test can put the map on any day.
///
/// `load(quietly: true)` is the tab coming back into view: it shows no
/// loading page and keeps what is on screen if the reload fails, and does
/// nothing unless the page is settled on [HomeReady].
@injectable
final class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._loadMap, this._completeTask, this._readSnapshot)
    : clock = DateTime.now,
      super(const HomeLoading(ChildSnapshotReadModel.empty));

  final LoadStudyMapUseCase _loadMap;

  final CompleteTaskUseCase _completeTask;

  final ReadChildSnapshotUseCase _readSnapshot;

  DateTime Function() clock;

  Future<void> load({bool quietly = false}) async {
    if (quietly && state is! HomeReady) return;
    if (!quietly) emit(HomeLoading(_readSnapshot()));

    final result = await _loadMap(now: clock());
    if (isClosed) return;

    switch (result) {
      case Left(:final value):
        if (!quietly) emit(HomeFailed(value));
      case Right(:final value):
        emit(HomeReady(value));
    }
  }

  Future<void> complete(String taskId) async {
    final HomeState current = state;
    final StudyMapReadModel? map = switch (current) {
      HomeReady(:final map) ||
      HomeCompleteFailed(:final map) ||
      HomeCompleting(:final map) => map,
      HomeLoading() || HomeFailed() => null,
    };
    if (map == null || current is HomeCompleting) return;

    emit(HomeCompleting(map, taskId));

    final completed = await _completeTask(taskId);
    if (isClosed) return;
    if (completed.isLeft) {
      emit(HomeCompleteFailed(map, completed.left));
      return;
    }

    final reloaded = await _loadMap(now: clock());
    if (isClosed) return;

    emit(switch (reloaded) {
      Left(:final value) => HomeCompleteFailed(map, value),
      Right(:final value) => HomeReady(value),
    });
  }
}
