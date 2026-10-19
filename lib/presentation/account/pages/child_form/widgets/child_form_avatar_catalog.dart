import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/application/account/cubit/child_form/child_form_cubit.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_gender_enum.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_form/items/child_form_avatar_tile.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_form/widgets/child_form_avatar_placeholders.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_error_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The face catalogue, in whichever of its three states it is in.
///
/// Waiting is a grid of empty discs the size of the faces to come, because
/// the grid's height is known and a spinner would make the form jump when the
/// faces land. Failed is the app's error card with its retry. Ready is the
/// faces filed under [gender], four to a row, with [selectedId] ringed.
///
/// The line under it says what is going on in words: loading, pick one, or
/// the name of the one picked. [onPick] chooses a face and [onRetry] asks for
/// the catalogue again.
class ChildFormAvatarCatalog extends StatelessWidget {
  const ChildFormAvatarCatalog({
    required this.state,
    required this.gender,
    required this.selectedId,
    required this.onPick,
    required this.onRetry,
    super.key,
  });

  static const int columns = 4;

  final ChildFormState state;

  final AvatarGenderEnum gender;

  final String? selectedId;

  final ValueChanged<AvatarEntity> onPick;

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);

    final List<AvatarEntity>? avatars = switch (state) {
      ChildFormReady(:final avatars) ||
      ChildFormSaving(:final avatars) ||
      ChildFormSaveFailed(:final avatars) => avatars,
      ChildFormLoadingAvatars() ||
      ChildFormAvatarsFailed() ||
      ChildFormSaved() => null,
    };

    if (state is ChildFormAvatarsFailed) {
      return AppErrorView(
        message: l10n.childFormAvatarsFailed,
        onRetry: onRetry,
      );
    }

    final String caption;
    final Widget grid;
    if (avatars == null) {
      caption = l10n.childFormAvatarsLoading;
      grid = const ChildFormAvatarPlaceholders(columns: columns);
    } else {
      AvatarEntity? picked;
      for (final AvatarEntity avatar in avatars) {
        if (avatar.id == selectedId) picked = avatar;
      }
      caption = picked == null
          ? l10n.childFormAvatarPick
          : l10n.childFormAvatarPicked(picked.name);
      grid = GridView.count(
        crossAxisCount: columns,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          for (final AvatarEntity avatar in avatars)
            if (avatar.isFor(gender))
              ChildFormAvatarTile(
                avatar: avatar,
                isSelected: avatar.id == selectedId,
                onTap: () => onPick(avatar),
              ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        grid,
        const SizedBox(height: AppSpacing.md),
        AppText(
          caption,
          type: AppTextTypeEnum.meta,
          color: AppPalette.of(context).onSurfaceMuted,
        ),
      ],
    );
  }
}
