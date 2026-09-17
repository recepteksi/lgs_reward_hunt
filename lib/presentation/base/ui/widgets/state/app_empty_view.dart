import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// A page with nothing in it yet, and the way out.
///
/// Empty is not an error and is not styled like one: neutral ink, no warning
/// colour, no red. Most empties in this app are somebody else's turn — no tasks
/// today means no one has set any — so the view says whose turn it is and
/// offers the action rather than apologising.
///
/// [message] is the sentence and [caption] the quieter line under it, both
/// already localized. [actionLabel] and [onAction] arrive together or not at
/// all: an emptiness nobody can do anything about should not grow a button for
/// the sake of symmetry.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.message,
    this.caption,
    this.icon = AppIcons.empty,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  static const double _tile = 44;

  final String message;

  final String? caption;

  final String icon;

  final String? actionLabel;

  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final String? caption = this.caption;
    final String? actionLabel = this.actionLabel;
    final VoidCallback? onAction = this.onAction;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: _tile,
            height: _tile,
            decoration: BoxDecoration(
              color: palette.surfaceHigh,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Center(
              child: AppIcon(
                icon,
                color: palette.onSurfaceMuted,
                size: AppSizes.iconSizeLarge,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppText(
            message,
            type: AppTextTypeEnum.body,
            textAlign: TextAlign.center,
            weight: FontWeight.w900,
            color: palette.onSurfaceVariant,
          ),
          if (caption != null) ...<Widget>[
            const SizedBox(height: AppSpacing.xs),
            AppText(
              caption,
              type: AppTextTypeEnum.meta,
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null && onAction != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            AppButton.tonal(label: actionLabel, onPressed: onAction),
          ],
        ],
      ),
    );
  }
}
