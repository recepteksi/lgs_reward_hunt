import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/duration_constants.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/badge/app_points_badge.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The child's balance, floating over a tab's top-right corner, and the
/// "+20P" that rises off it when points arrive.
///
/// The rise is the whole reward for ticking a task: no dialog, no confetti,
/// the number the child is saving goes up and says by how much. It plays when
/// [balance] grows between two builds, and not on the first one — opening the
/// app is not earning.
class AppBalancePill extends StatefulWidget {
  const AppBalancePill({required this.balance, super.key});

  final int balance;

  @override
  State<AppBalancePill> createState() => _AppBalancePillState();
}

/// Holds the rise animation and how much it is showing.
class _AppBalancePillState extends State<AppBalancePill>
    with SingleTickerProviderStateMixin {
  static const double _rise = 26;

  static const double _riseTop = -4;

  static const double _riseRight = 12;

  late final AnimationController _flash = AnimationController(
    vsync: this,
    duration: DurationConstants.pointsFlash,
  );

  int _gained = ValueConstants.zero;

  @override
  void didUpdateWidget(AppBalancePill oldWidget) {
    super.didUpdateWidget(oldWidget);
    final int gained = widget.balance - oldWidget.balance;
    if (gained > ValueConstants.zero) {
      _gained = gained;
      _flash.forward(from: ValueConstants.zeroDouble);
    }
  }

  @override
  void dispose() {
    _flash.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        AppPointsBadge.prominent(points: widget.balance),
        Positioned(
          top: _riseTop,
          right: _riseRight,
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _flash,
              builder: (BuildContext context, Widget? child) {
                final double t = _flash.value;
                return Opacity(
                  opacity: _flash.isAnimating
                      ? (ValueConstants.oneDouble - t)
                      : ValueConstants.zeroDouble,
                  child: Transform.translate(
                    offset: Offset(ValueConstants.zeroDouble, -_rise * t),
                    child: child,
                  ),
                );
              },
              child: AppText(
                AppL10n.of(context).mapStopEarned(_gained),
                type: AppTextTypeEnum.title,
                color: palette.rewardInk,
                weight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
