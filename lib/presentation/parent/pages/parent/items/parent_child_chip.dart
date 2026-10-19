import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/avatar/app_avatar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One child in the switch: face and name, filled when it is the device's.
///
/// [child] and [avatar] are the child, [isSelected] whether the device is on
/// them, and [onTap] switches to them — null for the one already chosen.
class ParentChildChip extends StatelessWidget {
  const ParentChildChip({
    required this.child,
    required this.avatar,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  static const double _face = 28;

  final ChildEntity child;

  final AvatarEntity? avatar;

  final bool isSelected;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Semantics(
      button: true,
      selected: isSelected,
      label: child.name,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: AppSizes.minTapTarget,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected ? palette.primaryContainer : palette.surface,
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          child: Row(
            children: <Widget>[
              AppAvatar(avatar: avatar, size: _face),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppText(
                  child.name,
                  type: AppTextTypeEnum.badge,
                  weight: FontWeight.w800,
                  color: isSelected
                      ? palette.onPrimaryContainer
                      : palette.onSurfaceMuted,
                  maxLines: ValueConstants.one,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
