import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_household_use_case.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/remove_child_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/household_read_model.dart';

part 'child_setup_state.dart';

/// The child setup step: who is in the household, and adding or removing them.
///
/// [load] reads the household, and is called again when the child form closes
/// — the list is the server's, not a copy the page keeps in step by hand.
/// [remove] takes a child out and reloads; a failed removal shows as a failed
/// page with a retry, because a list that silently kept the child would be a
/// list that lied.
@injectable
final class ChildSetupCubit extends Cubit<ChildSetupState> {
  ChildSetupCubit(this._loadHousehold, this._removeChild)
    : super(const ChildSetupLoading());

  final LoadHouseholdUseCase _loadHousehold;

  final RemoveChildUseCase _removeChild;

  Future<void> load() async {
    emit(const ChildSetupLoading());

    final result = await _loadHousehold();
    if (isClosed) return;

    emit(switch (result) {
      Left(:final value) => ChildSetupFailed(value),
      Right(:final value) => ChildSetupLoaded(value),
    });
  }

  Future<void> remove(String childId) async {
    emit(const ChildSetupLoading());

    final result = await _removeChild(childId);
    if (isClosed) return;

    if (result.isLeft) {
      emit(ChildSetupFailed(result.left));
      return;
    }
    await load();
  }
}
