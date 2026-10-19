import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_gender_enum.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_style_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/avatar/app_avatar.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_caption.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_panel.dart';

/// Section 12: the avatar, in every hair style the catalogue can name.
///
/// One face per [AvatarStyleEnum], so a style whose shapes break shows up here
/// before it shows up on a child's profile. The recipe's colours are borrowed
/// from the palette — a real face's come from the catalogue, and a hex written
/// here would be the one colour on the sheet nobody can re-theme. The second row is the three sizes a face is drawn
/// at — the switcher, the list row, the setup grid — with the grid one
/// selected, and the empty disc a child without a face gets.
class UiKitAvatarsSection extends StatelessWidget {
  const UiKitAvatarsSection({super.key});

  static const double _rowSize = 52;

  static const double _gridSize = 72;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final List<AvatarEntity> faces = <AvatarEntity>[
      for (final AvatarStyleEnum style in AvatarStyleEnum.values)
        AvatarEntity(
          id: style.name,
          name: style.name,
          gender: AvatarGenderEnum.girl,
          style: style,
          skin: palette.rewardContainer.toARGB32(),
          hair: palette.onSurface.toARGB32(),
          shirt: palette.primary.toARGB32(),
          background: palette.primaryContainer.toARGB32(),
          accessory: style == AvatarStyleEnum.cap
              ? palette.error.toARGB32()
              : null,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        UiKitPanel(
          children: <Widget>[
            const UiKitCaption('Styles'),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: <Widget>[
                for (final AvatarEntity face in faces)
                  AppAvatar(avatar: face, size: _rowSize),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        UiKitPanel(
          children: <Widget>[
            const UiKitCaption('Sizes · selected · no face'),
            Row(
              children: <Widget>[
                AppAvatar(avatar: faces.first),
                const SizedBox(width: AppSpacing.md),
                AppAvatar(avatar: faces.first, size: _rowSize),
                const SizedBox(width: AppSpacing.md),
                AppAvatar(
                  avatar: faces.first,
                  size: _gridSize,
                  isSelected: true,
                ),
                const SizedBox(width: AppSpacing.md),
                const AppAvatar(avatar: null, size: AppSizes.avatarTile),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
