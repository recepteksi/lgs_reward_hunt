import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/avatar/app_avatar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// Whose tab this is, floating over its top-left corner: face, name, and a
/// line about where they are.
///
/// On the navigation bar's frosted ground rather than the page's, so it reads
/// over a map or a list scrolling beneath it. It is the `start` of every
/// child tab's `AppAppBar.overlay`. [name] and [avatar] are the child;
/// [subtitle] is the tab's own line, already localized — the map says the
/// stretch of road and month, the shop says the grade.
class AppChildPill extends StatelessWidget {
  const AppChildPill({
    required this.name,
    required this.avatar,
    required this.subtitle,
    super.key,
  });

  static const double _face = 32;

  final String name;

  final AvatarEntity? avatar;

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: palette.navigationBar,
        borderRadius: BorderRadius.circular(AppRadii.round),
        border: Border.all(color: palette.mapEdge, width: AppSizes.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppAvatar(avatar: avatar, size: _face),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  name,
                  maxLines: ValueConstants.one,
                  overflow: TextOverflow.ellipsis,
                  type: AppTextTypeEnum.badge,
                  weight: FontWeight.w900,
                ),
                AppText(
                  subtitle,
                  type: AppTextTypeEnum.label,
                  color: palette.onSurfaceMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
