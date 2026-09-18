import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/points/rules/points_rules.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_stepper_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// Minus, a figure, plus.
///
/// Used where a parent sets how many points a task is worth. It steps rather
/// than accepting free entry, because the value is a currency the parent is
/// minting: a keyboard invites 1000, and the economy the reward shop was priced
/// against does not survive it.
///
/// The plus is tinted and the minus is neutral — increasing is the common move,
/// and the pair should not read as two equal choices.
///
/// [value] is the figure, [step] how far each tap moves it, and [minimum] and
/// [maximum] the ends, where the corresponding button greys out rather than
/// disappearing.
class AppStepper extends StatelessWidget {
  const AppStepper({
    required this.value,
    required this.onChanged,
    required this.decreaseLabel,
    required this.increaseLabel,
    this.step = PointsRules.minTaskPoints,
    this.minimum = PointsRules.minTaskPoints,
    this.maximum = PointsRules.maxTaskPoints,
    super.key,
  });

  static const double _button = 38;

  static const double _valueWidth = 34;

  final int value;

  final ValueChanged<int> onChanged;

  final String decreaseLabel;

  final String increaseLabel;

  final int step;

  final int minimum;

  final int maximum;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final bool canDecrease = value - step >= minimum;
    final bool canIncrease = value + step <= maximum;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppStepperButton(
          icon: AppIcons.forward,
          semanticLabel: decreaseLabel,
          background: palette.surfaceHigh,
          foreground: canDecrease ? palette.onSurface : palette.onSurfaceMuted,
          quarterTurns: ValueConstants.two,
          size: _button,
          onPressed: canDecrease ? () => onChanged(value - step) : null,
        ),
        SizedBox(
          width: _valueWidth + AppSpacing.lg,
          child: AppText(
            '$value',
            type: AppTextTypeEnum.cost,
            textAlign: TextAlign.center,
            color: palette.onSurface,
          ),
        ),
        AppStepperButton(
          icon: AppIcons.plus,
          semanticLabel: increaseLabel,
          background: palette.primaryContainer,
          foreground: canIncrease ? palette.primary : palette.onSurfaceMuted,
          size: _button,
          onPressed: canIncrease ? () => onChanged(value + step) : null,
        ),
      ],
    );
  }
}
