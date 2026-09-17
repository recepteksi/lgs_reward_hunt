import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/add_child_use_case.dart';
import 'package:lgs_reward_hunt/application/avatar/use_cases/load_avatars_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';

part 'child_form_state.dart';

/// The child form: the face catalogue, and saving the child.
///
/// What is being typed and tapped — the name, the grade, the tab, the chosen
/// face — stays in the form, the same way a text field's contents do. The
/// Cubit owns the two things that go over the wire: [loadAvatars], which the
/// form can retry, and [save], which ends the page.
///
/// A failed save goes back to the catalogue it was saved from, carrying the
/// failure, so the form redraws with everything the parent picked still
/// picked.
@injectable
final class ChildFormCubit extends Cubit<ChildFormState> {
  ChildFormCubit(this._loadAvatars, this._addChild)
    : super(const ChildFormLoadingAvatars());

  final LoadAvatarsUseCase _loadAvatars;

  final AddChildUseCase _addChild;

  Future<void> loadAvatars() async {
    emit(const ChildFormLoadingAvatars());

    final result = await _loadAvatars();
    if (isClosed) return;

    emit(switch (result) {
      Left(:final value) => ChildFormAvatarsFailed(value),
      Right(:final value) => ChildFormReady(value),
    });
  }

  Future<void> save({
    required String name,
    required int gradeLevel,
    required String? avatarId,
  }) async {
    final ChildFormState current = state;
    final List<AvatarEntity> avatars = switch (current) {
      ChildFormReady(:final avatars) ||
      ChildFormSaveFailed(:final avatars) => avatars,
      ChildFormLoadingAvatars() ||
      ChildFormAvatarsFailed() ||
      ChildFormSaving() ||
      ChildFormSaved() => const <AvatarEntity>[],
    };
    if (avatars.isEmpty) return;

    emit(ChildFormSaving(avatars));

    final result = await _addChild(
      name: name,
      gradeLevel: gradeLevel,
      avatarId: avatarId,
    );
    if (isClosed) return;

    emit(switch (result) {
      Left(:final value) => ChildFormSaveFailed(avatars, value),
      Right() => const ChildFormSaved(),
    });
  }
}
