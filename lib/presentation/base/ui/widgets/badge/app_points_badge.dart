import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// A points figure, in the colour that means points.
///
/// The one shape the whole economy is read through: a star and a number, on the
/// bar, on a task's row, on a reward's card. It is the reason the reward colour
/// is reserved — a colour that appears in a heading and in a balance means
/// neither, and the balance is the number this app asks a student to care
/// about.
///
/// The figure is grouped by the reader's locale, so a Turkish thousand is
/// `1.240` and an English one `1,240`, and it is set in tabular figures so a
/// balance that changes does not shift the badge under the thumb about to tap
/// it.
///
/// The default is the quiet pill — reward ink on the soft ground, outlined —
/// for a bar or a list row where the badge is one of many.
/// [AppPointsBadge.prominent] is the solid one, sitting on its own edge, for
/// the balance a screen is actually about.
///
/// [points] is the figure. A badge is not a button and may sit below the 44
/// pixel minimum; whatever it is inside is what has to meet it.
class AppPointsBadge extends StatelessWidget {
  const AppPointsBadge({required this.points, super.key})
    : _isProminent = false;

  const AppPointsBadge.prominent({required this.points, super.key})
    : _isProminent = true;

  final int points;

  final bool _isProminent;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final Color foreground = _isProminent
        ? palette.onReward
        : palette.rewardInk;

    return Container(
      height: _isProminent ? AppSizes.pointsPillLarge : AppSizes.pointsPill,
      padding: EdgeInsets.only(
        left: _isProminent ? AppSpacing.md : AppSpacing.sm,
        right: _isProminent ? AppSpacing.lg : AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: _isProminent ? palette.reward : palette.rewardSoft,
        borderRadius: BorderRadius.circular(AppRadii.round),
        border: _isProminent
            ? null
            : Border.all(color: palette.reward, width: AppSizes.border),
        boxShadow: _isProminent
            ? <BoxShadow>[
                BoxShadow(
                  color: palette.rewardEdge,
                  offset: const Offset(
                    ValueConstants.zeroDouble,
                    AppSizes.edgeDepthDisabled,
                  ),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppIcon(
            AppIcons.star,
            color: _isProminent ? palette.onReward : palette.reward,
            size: _isProminent ? AppSizes.iconSize : AppSizes.iconSizeSmall,
          ),
          const SizedBox(width: AppSpacing.sm),
          AppText(
            NumberFormat.decimalPattern(
              Localizations.localeOf(context).toLanguageTag(),
            ).format(points),
            type: AppTextTypeEnum.badge,
            color: foreground,
            style: TextStyle(
              fontSize: _isProminent
                  ? AppTypography.balance
                  : AppTypography.badge,
            ),
          ),
        ],
      ),
    );
  }
}
