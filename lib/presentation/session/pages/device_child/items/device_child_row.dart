import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/avatar/app_avatar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One child to hand the device to: face, name, grade and balance.
///
/// The whole card is the button, and a chevron says so. [isActive] outlines
/// the child the device opens on now in the primary colour. [avatar] may be
/// null, which draws the empty disc; [balance] is the child's points right now;
/// [onTap] picks this child.
class DeviceChildRow extends StatelessWidget {
  const DeviceChildRow({
    required this.child,
    required this.avatar,
    required this.balance,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  static const double _face = 56;

  final ChildEntity child;

  final AvatarEntity? avatar;

  final int balance;

  final bool isActive;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);

    return Semantics(
      button: true,
      selected: isActive,
      child: AppCard(
        radius: AppRadii.xl,
        border: BorderSide(
          color: isActive ? palette.primary : palette.outline,
          width: AppSizes.borderThick,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        onTap: onTap,
        child: Row(
          children: <Widget>[
            AppAvatar(avatar: avatar, size: _face),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(
                    child.name,
                    type: AppTextTypeEnum.title,
                    weight: FontWeight.w900,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    l10n.deviceChildRowMeta(child.gradeLevel, balance),
                    type: AppTextTypeEnum.meta,
                    color: palette.onSurfaceMuted,
                  ),
                ],
              ),
            ),
            AppIcon(AppIcons.forward, color: palette.onSurfaceMuted),
          ],
        ),
      ),
    );
  }
}
