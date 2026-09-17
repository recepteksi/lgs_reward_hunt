import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// A line in a settings list: an icon, a name, a note, and a way on.
///
/// The rows sit in one card and are separated by a hairline rather than by
/// gaps, so the list reads as a single object with entries — which is what
/// stops a settings screen from looking like a pile of unrelated cards.
///
/// [trailing] replaces the chevron for the rows that are the control rather
/// than a door to one: a stepper, a switch. A row with a trailing control is
/// not tappable as a whole, because two targets in one row is how a parent ends
/// up opening a screen when they meant to add a point.
///
/// [icon] is optional — a row whose meaning is carried by its own control does
/// not need a glyph as well.
class AppSettingsRow extends StatelessWidget {
  const AppSettingsRow({
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;

  final String? subtitle;

  final String? icon;

  final Widget? trailing;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final String? subtitle = this.subtitle;
    final String? icon = this.icon;
    final Widget? trailing = this.trailing;

    return InkWell(
      onTap: trailing == null ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Container(
                width: AppSizes.avatarTile,
                height: AppSizes.avatarTile,
                decoration: BoxDecoration(
                  color: palette.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                child: Center(
                  child: AppIcon(
                    icon,
                    color: palette.primary,
                    size: AppSizes.iconSize,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppText(
                    title,
                    type: AppTextTypeEnum.body,
                    color: palette.onSurface,
                  ),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.xs),
                    AppText(subtitle, type: AppTextTypeEnum.caption),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            trailing ??
                AppIcon(
                  AppIcons.forward,
                  color: palette.onSurfaceMuted,
                  size: AppSizes.iconSizeMedium,
                ),
          ],
        ),
      ),
    );
  }
}
