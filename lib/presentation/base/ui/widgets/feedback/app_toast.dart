import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// A short confirmation, shown and then gone.
///
/// Two kinds, because the app has two kinds of good news.
/// [AppToast.reward] is points arriving and wears the reward colour and the
/// star — it is the receipt for the thing the whole loop is about, and it earns
/// the loudest surface in the palette. [AppToast.info] is everything else
/// ("your request went to your mother"), and it is the inverse of the page:
/// dark ink as the ground, so it is unmistakably a notice rather than another
/// card that arrived.
///
/// Neither carries an action. A toast a student must catch and tap is a toast
/// that should have been a screen.
///
/// [message] is the sentence, already localized.
class AppToast extends StatelessWidget {
  const AppToast.reward({required this.message, super.key}) : _isReward = true;

  const AppToast.info({required this.message, super.key}) : _isReward = false;

  final String message;

  final bool _isReward;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final Color foreground = _isReward ? palette.onReward : palette.surface;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: _isReward ? palette.reward : palette.onSurface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: _isReward
            ? <BoxShadow>[
                BoxShadow(
                  color: palette.rewardEdge,
                  offset: const Offset(
                    ValueConstants.zeroDouble,
                    AppSizes.edgeDepth,
                  ),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppIcon(
            _isReward ? AppIcons.star : AppIcons.check,
            color: foreground,
            size: AppSizes.iconSize,
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: AppText(
              message,
              type: AppTextTypeEnum.badge,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
