import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The week, one bar per day.
///
/// Seven bars and no axis, no gridlines and no numbers: the question it answers
/// is "how has this week gone", which is a shape rather than a figure, and
/// every mark added to it makes the shape harder to see. A day with nothing
/// done still gets a stub so that the week reads as seven days rather than as
/// four.
///
/// Today is drawn in the reward colour and every other day in the primary,
/// which is the only place in the app those two sit side by side — here the
/// contrast is the point: it says which bar is still being written.
///
/// The chart has no fixed height: the tallest bar sets it, and the row aligns
/// every column on the labels underneath. A fixed frame is how a bar and its
/// label end up six pixels taller than the box they were given.
///
/// [values] and [labels] are read in step and the shorter one wins, so a caller
/// that hands over six labels for seven days draws six days instead of
/// throwing. [highlightedIndex] is today.
class AppWeekChart extends StatelessWidget {
  const AppWeekChart({
    required this.values,
    required this.labels,
    required this.highlightedIndex,
    super.key,
  });

  static const double _unit = 20;

  static const double _minimumBar = 8;

  final List<int> values;

  final List<String> labels;

  final int highlightedIndex;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final int count = values.length < labels.length
        ? values.length
        : labels.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        for (int day = ValueConstants.zero; day < count; day++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: _barHeight(values[day]),
                    decoration: BoxDecoration(
                      color: day == highlightedIndex
                          ? palette.reward
                          : values[day] > ValueConstants.zero
                          ? palette.primary
                          : palette.surfaceHigh,
                      borderRadius: BorderRadius.circular(AppRadii.xs),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppText(
                    labels[day],
                    type: AppTextTypeEnum.label,
                    color: day == highlightedIndex
                        ? palette.rewardInk
                        : palette.onSurfaceMuted,
                    style: const TextStyle(
                      letterSpacing: ValueConstants.zeroDouble,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  double _barHeight(int value) {
    final double raw = value * _unit;

    return raw < _minimumBar ? _minimumBar : raw;
  }
}
