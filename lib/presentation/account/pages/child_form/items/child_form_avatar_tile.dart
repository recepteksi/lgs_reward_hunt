import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/avatar/app_avatar.dart';

/// One face in the catalogue grid, as a button.
///
/// The face fills its grid cell, whatever width four columns leave on the
/// phone. [isSelected] rings it; [onTap] picks it. The face's suggested name
/// is what a screen reader hears.
class ChildFormAvatarTile extends StatelessWidget {
  const ChildFormAvatarTile({
    required this.avatar,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final AvatarEntity avatar;

  final bool isSelected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: avatar.name,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) => AppAvatar(
            avatar: avatar,
            size: constraints.maxWidth,
            isSelected: isSelected,
          ),
        ),
      ),
    );
  }
}
