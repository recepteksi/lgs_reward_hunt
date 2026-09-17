import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// A square icon tile, then a title over a figure — the head of both cards on
/// the rewards slide.
///
/// The colours are the caller's because the two cards speak differently: the
/// balance in the reward inks, the request on the plain surface. [tileColor]
/// and [iconColor] paint the tile, [titleColor] and [metaColor] the two lines.
/// [_tile] and [_tileIcon] are the design's measurements for the square.
class IntroRewardLine extends StatelessWidget {
  const IntroRewardLine({
    required this.tileColor,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.meta,
    required this.metaColor,
    super.key,
  });

  static const double _tile = 52;

  static const double _tileIcon = 24;

  final Color tileColor;

  final String icon;

  final Color iconColor;

  final String title;

  final Color titleColor;

  final String meta;

  final Color metaColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: _tile,
          height: _tile,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          child: AppIcon(icon, color: iconColor, size: _tileIcon),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppText(
                title,
                type: AppTextTypeEnum.title,
                color: titleColor,
                weight: FontWeight.w900,
                maxLines: ValueConstants.one,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText(
                meta,
                type: AppTextTypeEnum.meta,
                color: metaColor,
                weight: FontWeight.w800,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
