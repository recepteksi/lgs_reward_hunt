import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The first slide's picture: the mark on a disc, with a points coin beside it.
///
/// A tilted tile in the primary colour on its pale container, and a coin in the
/// reward colour cut out of the ground by a ring of the background — the two
/// colours the whole app is built from, introduced before any screen uses them.
/// The coin is the reward colour because it is the points; nothing else on the
/// slide is.
///
/// [_disc], [_tile], [_tileRadius], [_coin], [_coinRing] and the coin's
/// [_coinRight] / [_coinBottom] offsets are the design's own measurements for
/// this one picture, and [_tilt] is its six degrees, in radians.
class IntroEmblemArt extends StatelessWidget {
  const IntroEmblemArt({super.key});

  static const double _disc = 224;

  static const double _tile = 136;

  static const double _tileRadius = 36;

  static const double _coin = 68;

  static const double _coinRing = 5;

  static const double _coinRight = 2;

  static const double _coinBottom = 20;

  static const double _tilt = -0.105;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);

    return Container(
      width: _disc,
      height: _disc,
      decoration: BoxDecoration(
        color: palette.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Transform.rotate(
            angle: _tilt,
            child: Container(
              width: _tile,
              height: _tile,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette.primary,
                borderRadius: BorderRadius.circular(_tileRadius),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: palette.primaryShadow,
                    offset: const Offset(
                      ValueConstants.zeroDouble,
                      AppSizes.glowOffset,
                    ),
                    blurRadius: AppSizes.glowBlur,
                  ),
                ],
              ),
              child: AppText(
                l10n.introEmblemMark,
                type: AppTextTypeEnum.display,
                color: palette.onPrimary,
                weight: FontWeight.w900,
              ),
            ),
          ),
          Positioned(
            right: _coinRight,
            bottom: _coinBottom,
            child: Container(
              width: _coin,
              height: _coin,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette.reward,
                borderRadius: BorderRadius.circular(AppRadii.round),
                border: Border.all(color: palette.background, width: _coinRing),
              ),
              child: AppText(
                l10n.introEmblemPoints,
                type: AppTextTypeEnum.heading,
                color: palette.onReward,
                weight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
