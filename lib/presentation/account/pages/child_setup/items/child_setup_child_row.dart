import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/avatar/app_avatar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_icon_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One child already in the household: face, name, grade, and a way out.
///
/// [avatar] is looked up by the household and may be null, which draws the
/// empty disc and drops the face's name from the line under the child's.
/// [onRemove] is the cross on the right; it is only offered here, during
/// setup, where taking a child back out costs nothing.
class ChildSetupChildRow extends StatelessWidget {
  const ChildSetupChildRow({
    required this.child,
    required this.avatar,
    required this.onRemove,
    super.key,
  });

  static const double _face = 52;

  final ChildEntity child;

  final AvatarEntity? avatar;

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final AvatarEntity? avatar = this.avatar;

    return AppCard(
      radius: AppRadii.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
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
                AppText(
                  avatar == null
                      ? l10n.childSetupRowMetaNoAvatar(child.gradeLevel)
                      : l10n.childSetupRowMeta(child.gradeLevel, avatar.name),
                  type: AppTextTypeEnum.meta,
                  color: palette.onSurfaceMuted,
                ),
              ],
            ),
          ),
          AppIconButton.plain(
            icon: AppIcons.close,
            semanticLabel: l10n.childSetupRemove,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
