import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The end of the road: a reward-coloured disc with the star and the exam's
/// name, and the date under it.
///
/// The one place on the map the reward colour stands for something other than
/// points, and it is deliberate — the exam is what every point on the road is
/// for. It sits on a solid edge like a pressable stop but is not one: nothing
/// happens when it is tapped. [examDate] is the day of the exam, and
/// [discRadius] is what the map lines the disc's centre up by.
class HomeExamFlag extends StatelessWidget {
  const HomeExamFlag({required this.examDate, super.key});

  static const double _disc = 80;

  static const double discRadius = _disc / 2;

  static const double _ring = 5;

  static const double _star = 30;

  static const double _edge = 8;

  final DateTime examDate;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: _disc,
          height: _disc,
          decoration: BoxDecoration(
            color: palette.reward,
            shape: BoxShape.circle,
            border: Border.all(color: palette.mapRing, width: _ring),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.rewardEdge,
                offset: const Offset(ValueConstants.zeroDouble, _edge),
              ),
              BoxShadow(
                color: palette.rewardShadow,
                offset: const Offset(
                  ValueConstants.zeroDouble,
                  AppSizes.glowOffset,
                ),
                blurRadius: AppSizes.glowBlur,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppIcon(AppIcons.star, color: palette.onReward, size: _star),
              AppText(
                l10n.mapExamMark,
                type: AppTextTypeEnum.label,
                color: palette.onReward,
                weight: FontWeight.w900,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppText(
          l10n.mapExamDay,
          type: AppTextTypeEnum.badge,
          color: palette.rewardInk,
          weight: FontWeight.w900,
        ),
        const SizedBox(height: AppSpacing.xs),
        AppText(
          DateFormat.yMMMMd(Localizations.localeOf(context).toLanguageTag())
              .format(examDate),
          type: AppTextTypeEnum.caption,
          color: palette.mapLockedInk,
          weight: FontWeight.w800,
        ),
      ],
    );
  }
}
