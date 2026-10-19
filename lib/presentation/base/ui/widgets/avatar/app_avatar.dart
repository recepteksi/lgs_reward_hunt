import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/avatar/app_avatar_markup.dart';

/// A child's face, drawn from the catalogue's recipe, in a disc.
///
/// The face is vector markup built by `AppAvatarMarkup`, so it is sharp at the
/// 38 pixels of a switcher and at the width of a grid cell alike, and the disc
/// behind it is the catalogue's own background colour. With no [avatar] — a
/// child who joined by link code, or a face the catalogue has dropped — the
/// disc is the neutral high surface and empty, which says "no face yet" rather
/// than drawing somebody else's.
///
/// [size] is the diameter. [isSelected] rings the disc in the primary colour
/// and lifts it slightly, which is how the setup grid shows the choice; the
/// ring sits inside the disc so a grid of selected and unselected faces keeps
/// its spacing.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.avatar,
    this.size = AppSizes.avatarTile,
    this.isSelected = false,
    super.key,
  });

  static const double _selectedScale = 1.06;

  static const double _ring = 3;

  final AvatarEntity? avatar;

  final double size;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AvatarEntity? avatar = this.avatar;

    return AnimatedScale(
      scale: isSelected ? _selectedScale : AppSizes.unitScale,
      duration: kThemeAnimationDuration,
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        foregroundDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: palette.primary, width: _ring)
              : null,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: avatar == null
              ? palette.surfaceHigh
              : Color(avatar.background),
        ),
        child: avatar == null
            ? null
            : SvgPicture.string(
                AppAvatarMarkup.of(avatar),
                width: size,
                height: size,
              ),
      ),
    );
  }
}
