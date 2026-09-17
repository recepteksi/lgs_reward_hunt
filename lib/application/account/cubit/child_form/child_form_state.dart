part of 'child_form_cubit.dart';

/// What the child form is showing.
///
/// The form itself is on screen in every state but [ChildFormSaved]; what
/// changes is the catalogue under it and whether the button can be pressed.
sealed class ChildFormState {
  const ChildFormState();
}

/// The catalogue is on its way; the grid shows placeholders.
final class ChildFormLoadingAvatars extends ChildFormState {
  const ChildFormLoadingAvatars();
}

/// The catalogue could not be fetched; the grid is a retry.
final class ChildFormAvatarsFailed extends ChildFormState {
  const ChildFormAvatarsFailed(this.failure);

  final Failure failure;
}

/// The faces are here and the child can be saved.
final class ChildFormReady extends ChildFormState {
  const ChildFormReady(this.avatars);

  final List<AvatarEntity> avatars;
}

/// The child is being added; the button waits.
final class ChildFormSaving extends ChildFormState {
  const ChildFormSaving(this.avatars);

  final List<AvatarEntity> avatars;
}

/// The child was refused; [failure] says why, under the button.
final class ChildFormSaveFailed extends ChildFormState {
  const ChildFormSaveFailed(this.avatars, this.failure);

  final List<AvatarEntity> avatars;

  final Failure failure;
}

/// The child is in the household; the page closes.
final class ChildFormSaved extends ChildFormState {
  const ChildFormSaved();
}
