import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One of the four tabs.
class AppNavTabItem extends StatelessWidget {
  const AppNavTabItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  static const double _iconBoxWidth = 38;

  static const double _iconBoxHeight = 30;

  static const double _tabHeight = 52;

  final String icon;

  final String label;

  final bool isSelected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final Color color = isSelected ? palette.primary : palette.onSurfaceMuted;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _tabHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: _iconBoxWidth,
                  height: _iconBoxHeight,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? palette.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  child: Center(
                    child: AppIcon(icon, color: color, size: AppSizes.iconSize),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  label,
                  type: AppTextTypeEnum.label,
                  color: color,
                  style: const TextStyle(
                    letterSpacing: ValueConstants.zeroDouble,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
