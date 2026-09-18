import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/map/app_map_stop_kind_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One stop on the path to the exam.
///
/// The map is the app's home, and a stop is a day on it. Size is the hierarchy:
/// today is the biggest thing on the screen by a wide margin, finished days are
/// small and solid, and days that have not arrived are small and quiet. A
/// student opening the app should find today without reading anything.
///
/// [AppMapStop.today] is the only one in the reward colour, and it is the only
/// one that is. [AppMapStop.done] is the primary, filled and ticked.
/// [AppMapStop.special] marks a heavier day — a practice exam, a weekly
/// review — with a star and a ring in the reward colour, so it is legible as
/// different before it is legible as locked or open. [AppMapStop.locked] and
/// [AppMapStop.selected] are the same muted stone; selection is a ring, not a
/// fill, because tapping a future day inspects it rather than opens it.
///
/// Every stop sits on a solid edge rather than a blurred shadow — the same
/// trick the buttons use, and the reason the path reads as a row of objects on
/// a surface instead of circles printed on one.
///
/// [label] is the day under the stop, and [day] the figure inside it.
class AppMapStop extends StatelessWidget {
  const AppMapStop.done({required this.label, this.onTap, super.key})
    : _kind = AppMapStopKindEnum.done,
      day = null;

  const AppMapStop.today({
    required this.day,
    required this.label,
    this.onTap,
    super.key,
  }) : _kind = AppMapStopKindEnum.today;

  const AppMapStop.special({required this.label, this.onTap, super.key})
    : _kind = AppMapStopKindEnum.special,
      day = null;

  const AppMapStop.locked({
    required this.day,
    required this.label,
    this.onTap,
    super.key,
  }) : _kind = AppMapStopKindEnum.locked;

  const AppMapStop.selected({
    required this.day,
    required this.label,
    this.onTap,
    super.key,
  }) : _kind = AppMapStopKindEnum.selected;

  static const double _sizeSmall = 50;

  static const double _sizeSpecial = 62;

  static const double _sizeToday = 78;

  static const double _ringThin = 3;

  static const double _ringThick = 4;

  static const double _todayEdge = 7;

  static const double _todayGlowOffset = 14;

  static const double _todayGlowBlur = 26;

  static const double _doneEdge = 6;

  static const double _doneGlowOffset = 12;

  static const double _doneGlowBlur = 22;

  final int? day;

  final String label;

  final VoidCallback? onTap;

  final AppMapStopKindEnum _kind;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final int? day = this.day;

    final double diameter = switch (_kind) {
      AppMapStopKindEnum.today => _sizeToday,
      AppMapStopKindEnum.special => _sizeSpecial,
      AppMapStopKindEnum.done ||
      AppMapStopKindEnum.locked ||
      AppMapStopKindEnum.selected => _sizeSmall,
    };
    final Color background = switch (_kind) {
      AppMapStopKindEnum.done => palette.primary,
      AppMapStopKindEnum.today => palette.reward,
      AppMapStopKindEnum.special => palette.rewardSoft,
      AppMapStopKindEnum.locked ||
      AppMapStopKindEnum.selected => palette.mapLocked,
    };
    final Color foreground = switch (_kind) {
      AppMapStopKindEnum.done => palette.onPrimary,
      AppMapStopKindEnum.today => palette.onReward,
      AppMapStopKindEnum.special => palette.rewardInk,
      AppMapStopKindEnum.locked ||
      AppMapStopKindEnum.selected => palette.mapLockedInk,
    };
    final Color ringColor = switch (_kind) {
      AppMapStopKindEnum.done || AppMapStopKindEnum.today => palette.mapRing,
      AppMapStopKindEnum.special ||
      AppMapStopKindEnum.selected => palette.reward,
      AppMapStopKindEnum.locked => palette.mapLockedEdge,
    };
    final double ringWidth = switch (_kind) {
      AppMapStopKindEnum.done ||
      AppMapStopKindEnum.today ||
      AppMapStopKindEnum.selected => _ringThick,
      AppMapStopKindEnum.special || AppMapStopKindEnum.locked => _ringThin,
    };

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              border: Border.all(color: ringColor, width: ringWidth),
              boxShadow: _shadows(palette),
            ),
            child: Center(
              child: switch (_kind) {
                AppMapStopKindEnum.done => AppIcon(
                  AppIcons.check,
                  color: foreground,
                  size: AppSizes.iconSize,
                ),
                AppMapStopKindEnum.special => AppIcon(
                  AppIcons.star,
                  color: foreground,
                  size: AppSizes.iconSize,
                ),
                AppMapStopKindEnum.today ||
                AppMapStopKindEnum.locked ||
                AppMapStopKindEnum.selected => AppText(
                  '${day ?? CharConstants.empty}',
                  type: AppTextTypeEnum.badge,
                  color: foreground,
                  style: TextStyle(
                    fontSize: _kind == AppMapStopKindEnum.today
                        ? AppTypography.heading
                        : AppTypography.title,
                  ),
                ),
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: _sizeToday,
            child: AppText(
              label,
              type: AppTextTypeEnum.caption,
              textAlign: TextAlign.center,
              weight: FontWeight.w800,
              color: palette.mapLockedInk,
              maxLines: ValueConstants.two,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  List<BoxShadow> _shadows(AppPalette palette) {
    return switch (_kind) {
      AppMapStopKindEnum.done => <BoxShadow>[
        BoxShadow(
          color: palette.primaryEdge,
          offset: const Offset(ValueConstants.zeroDouble, _doneEdge),
        ),
        BoxShadow(
          color: palette.primaryShadow,
          offset: const Offset(ValueConstants.zeroDouble, _doneGlowOffset),
          blurRadius: _doneGlowBlur,
        ),
      ],
      AppMapStopKindEnum.today => <BoxShadow>[
        BoxShadow(
          color: palette.rewardEdge,
          offset: const Offset(ValueConstants.zeroDouble, _todayEdge),
        ),
        BoxShadow(
          color: palette.rewardShadow,
          offset: const Offset(ValueConstants.zeroDouble, _todayGlowOffset),
          blurRadius: _todayGlowBlur,
        ),
      ],
      AppMapStopKindEnum.special => <BoxShadow>[
        BoxShadow(
          color: palette.rewardSoftEdge,
          offset: const Offset(ValueConstants.zeroDouble, AppSizes.edgeDepth),
        ),
      ],
      AppMapStopKindEnum.locked || AppMapStopKindEnum.selected => <BoxShadow>[
        BoxShadow(
          color: palette.mapLockedEdge,
          offset: const Offset(ValueConstants.zeroDouble, AppSizes.edgeDepth),
        ),
      ],
    };
  }
}
