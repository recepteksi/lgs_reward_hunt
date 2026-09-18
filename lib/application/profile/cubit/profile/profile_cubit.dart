import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/read_child_snapshot_use_case.dart';
import 'package:lgs_reward_hunt/application/profile/use_cases/load_profile_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_snapshot_read_model.dart';
import 'package:lgs_reward_hunt/domain/profile/read_models/profile_read_model.dart';

part 'profile_state.dart';

/// The profile tab: reads the child's profile.
///
/// The appearance card on the same tab talks to `AppearanceCubit`, the one
/// shell-level Cubit, rather than through this one — the choice re-themes the
/// whole app, and a copy of it here would be a second source of truth about
/// what colour the app is. [clock] is today's moment, injected for tests.
///
/// `load(quietly: true)` is the tab coming back into view: it shows no
/// loading page and keeps what is on screen if the reload fails, and does
/// nothing unless the page is settled on [ProfileReady].
@injectable
final class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._loadProfile, this._readSnapshot)
    : clock = DateTime.now,
      super(const ProfileLoading(ChildSnapshotReadModel.empty));

  final LoadProfileUseCase _loadProfile;

  final ReadChildSnapshotUseCase _readSnapshot;

  DateTime Function() clock;

  Future<void> load({bool quietly = false}) async {
    if (quietly && state is! ProfileReady) return;
    if (!quietly) emit(ProfileLoading(_readSnapshot()));

    final result = await _loadProfile(now: clock());
    if (isClosed) return;

    switch (result) {
      case Left(:final value):
        if (!quietly) emit(ProfileFailed(value));
      case Right(:final value):
        emit(ProfileReady(value));
    }
  }
}
