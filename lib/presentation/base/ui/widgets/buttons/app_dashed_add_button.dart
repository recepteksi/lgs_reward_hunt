import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_dashed_border_painter.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The dashed slot a new row goes into, at the foot of a list.
///
/// Dashed and empty rather than a filled button, because it stands where the
/// next row will be: it is the shape of the thing it adds. The setup steps end
/// their lists of children and of tasks with one.
///
/// [label] is what gets added, already localized, and [onPressed] adds it.
class AppDashedAddButton extends StatelessWidget {
  const AppDashedAddButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  static const double _height = 68;

  final String label;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: CustomPaint(
          painter: AppDashedBorderPainter(
            color: palette.outlineStrong,
            radius: AppRadii.lg,
            strokeWidth: AppSizes.borderThick,
          ),
          child: SizedBox(
            height: _height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppIcon(AppIcons.plus, color: palette.primary),
                const SizedBox(width: AppSpacing.sm),
                AppText(
                  label,
                  type: AppTextTypeEnum.button,
                  weight: FontWeight.w800,
                  color: palette.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
