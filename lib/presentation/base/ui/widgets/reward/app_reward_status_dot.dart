import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';

/// The small round mark at a card's shoulder: waiting, or done.
class AppRewardStatusDot extends StatelessWidget {
  const AppRewardStatusDot({
    super.key,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String icon;

  final Color background;

  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.statusDot,
      height: AppSizes.statusDot,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Center(
        child: AppIcon(icon, color: foreground, size: AppSizes.iconSizeSmall),
      ),
    );
  }
}
