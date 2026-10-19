import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_shimmer.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton.dart';

/// Shimmering discs where the faces will be, while the catalogue loads.
///
/// Two rows of [columns] — one tab's worth — each disc the size a face will
/// be, so the grid is the height it will be and nothing moves when the
/// faces arrive.
class ChildFormAvatarPlaceholders extends StatelessWidget {
  const ChildFormAvatarPlaceholders({required this.columns, super.key});

  final int columns;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: GridView.count(
        crossAxisCount: columns,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          for (
            int index = ValueConstants.zero;
            index < columns * ValueConstants.two;
            index++
          )
            LayoutBuilder(
              builder: (_, BoxConstraints constraints) =>
                  AppSkeleton.circle(size: constraints.maxWidth),
            ),
        ],
      ),
    );
  }
}
