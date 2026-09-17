import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';

/// The bordered box one group of specimens sits in.
///
/// Every panel on the sheet is the same surface, corner and hairline, so that
/// the differences a reader is meant to notice are the components inside them
/// and never the frames around them.
///
/// [children] are laid out in a column with the design's own gap between them;
/// a specimen that needs a row builds one itself.
class UiKitPanel extends StatelessWidget {
  const UiKitPanel({required this.children, this.color, super.key});

  final List<Widget> children;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: color,
      radius: AppRadii.xl,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (
            int index = ValueConstants.zero;
            index < children.length;
            index++
          ) ...<Widget>[
            if (index > ValueConstants.zero)
              const SizedBox(height: AppSpacing.md),
            children[index],
          ],
        ],
      ),
    );
  }
}
