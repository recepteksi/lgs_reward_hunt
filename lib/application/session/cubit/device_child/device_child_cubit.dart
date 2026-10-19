import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_device_choice_use_case.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/choose_device_child_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/device_choice_read_model.dart';

part 'device_child_state.dart';

/// The step that asks which child this device belongs to.
///
/// [load] reads the choice, and when there is nothing to choose — a single
/// child — it chooses that child straight away rather than showing a list of
/// one, which is what the design's end of setup does. [choose] stores the
/// pick; the page leaves when the state says [DeviceChildChosen].
@injectable
final class DeviceChildCubit extends Cubit<DeviceChildState> {
  DeviceChildCubit(this._loadChoice, this._choose)
    : super(const DeviceChildLoading());

  final LoadDeviceChoiceUseCase _loadChoice;

  final ChooseDeviceChildUseCase _choose;

  Future<void> load() async {
    emit(const DeviceChildLoading());

    final result = await _loadChoice();
    if (isClosed) return;

    if (result.isLeft) {
      emit(DeviceChildFailed(result.left));
      return;
    }

    final DeviceChoiceReadModel choice = result.right;
    if (!choice.needsChoice && choice.household.hasChild) {
      await choose(choice.household.children.single.id);
      return;
    }
    emit(DeviceChildChoosing(choice));
  }

  Future<void> choose(String childId) async {
    emit(const DeviceChildLoading());

    final result = await _choose(childId);
    if (isClosed) return;

    emit(switch (result) {
      Left(:final value) => DeviceChildFailed(value),
      Right() => const DeviceChildChosen(),
    });
  }
}
