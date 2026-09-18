import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';

/// Four boxes that fill as the code is typed.
///
/// Boxes rather than a text field: there is nothing to select, nothing to
/// paste, and the keypad below is the only way in. The box being filled carries
/// the primary outline, which is the only cursor a keypad needs.
class AppPinDots extends StatelessWidget {
  const AppPinDots({required this.filled, required this.total, super.key});

  static const double _box = 52;

  static const double _dot = 12;

  final int filled;

  final int total;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int index = ValueConstants.zero; index < total; index++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Container(
              width: _box,
              height: _box,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(AppSpacing.lg),
                border: Border.all(
                  color: index == filled
                      ? palette.primary
                      : palette.outlineStrong,
                  width: AppSizes.borderStrong,
                ),
              ),
              child: index < filled
                  ? Container(
                      width: _dot,
                      height: _dot,
                      decoration: BoxDecoration(
                        color: palette.onSurface,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}
