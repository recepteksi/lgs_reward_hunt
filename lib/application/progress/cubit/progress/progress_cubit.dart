import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_child_header_use_case.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/read_child_snapshot_use_case.dart';
import 'package:lgs_reward_hunt/application/progress/use_cases/load_progress_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_header_read_model.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_snapshot_read_model.dart';
import 'package:lgs_reward_hunt/domain/progress/read_models/progress_read_model.dart';

part 'progress_state.dart';

/// The progress tab: whose it is, and how they are doing.
///
/// Read-only — nothing on the tab changes anything — so [load] is the whole
/// of it. [clock] is today's moment, injected so a test can stand on any day.
///
/// `load(quietly: true)` is the tab coming back into view: it shows no
/// loading page and keeps what is on screen if the reload fails, and does
/// nothing unless the page is settled on [ProgressReady].
@injectable
final class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit(this._loadHeader, this._loadProgress, this._readSnapshot)
    : clock = DateTime.now,
      super(const ProgressLoading(ChildSnapshotReadModel.empty));

  final LoadChildHeaderUseCase _loadHeader;

  final LoadProgressUseCase _loadProgress;

  final ReadChildSnapshotUseCase _readSnapshot;

  DateTime Function() clock;

  Future<void> load({bool quietly = false}) async {
    if (quietly && state is! ProgressReady) return;
    if (!quietly) emit(ProgressLoading(_readSnapshot()));

    final header = await _loadHeader();
    if (isClosed) return;
    if (header.isLeft) {
      if (!quietly) emit(ProgressFailed(header.left));
      return;
    }

    final progress = await _loadProgress(
      childId: header.right.child.id,
      now: clock(),
    );
    if (isClosed) return;

    switch (progress) {
      case Left(:final value):
        if (!quietly) emit(ProgressFailed(value));
      case Right(:final value):
        emit(ProgressReady(header.right, value));
    }
  }
}
