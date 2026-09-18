import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_shimmer.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton.dart';

/// The map before the path has loaded: the map ground, a zigzag of stop
/// shapes, and the day sheet with two task rows — all where the real ones
/// will land, so nothing jumps.
class HomeMapSkeleton extends StatelessWidget {
  const HomeMapSkeleton({super.key});

  static const double _stop = 48;

  static const double _today = 64;

  static const double _step = 72;

  static const double _firstTop = 140;

  static const List<double> _offsets = <double>[0, -0.45, 0, 0.45, 0, -0.45];

  static const int _todayIndex = 3;

  static const double _sheetHeight = 220;

  static const double _handle = 36;

  static const double _handleHeight = 4;

  static const double _titleWidth = 140;

  static const double _rowWidth = 180;

  static const double _metaWidth = 90;

  static const int _rows = 2;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return ColoredBox(
      color: palette.mapBase,
      child: Stack(
        children: <Widget>[
          AppShimmer(
            child: Stack(
              children: <Widget>[
                for (int i = ValueConstants.zero; i < _offsets.length; i++)
                  Positioned.fill(
                    top: _firstTop + i * _step,
                    child: Align(
                      alignment: Alignment(
                        _offsets[i],
                        -ValueConstants.oneDouble,
                      ),
                      child: AppSkeleton.circle(
                        size: i == _todayIndex ? _today : _stop,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            left: ValueConstants.zeroDouble,
            right: ValueConstants.zeroDouble,
            bottom: ValueConstants.zeroDouble,
            height: _sheetHeight,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadii.xxxl),
                ),
              ),
              child: AppShimmer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Center(
                      child: AppSkeleton(
                        width: _handle,
                        height: _handleHeight,
                        radius: AppRadii.round,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const AppSkeleton.line(
                      width: _titleWidth,
                      size: AppTypography.title,
                    ),
                    for (
                      int i = ValueConstants.zero;
                      i < _rows;
                      i++
                    ) ...<Widget>[
                      const SizedBox(height: AppSpacing.lg),
                      const Row(
                        children: <Widget>[
                          AppSkeleton.circle(size: AppSizes.taskCheck),
                          SizedBox(width: AppSpacing.md),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppSkeleton.line(width: _rowWidth),
                              SizedBox(height: AppSpacing.xs),
                              AppSkeleton.line(
                                width: _metaWidth,
                                size: AppTypography.caption,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
