import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';

/// A surface with the app's corner and its hairline.
///
/// Material's own `Card` would do, were it not that half the cards in this
/// design are tappable and the other half carry a tinted ground — a reward on
/// the surface, an approved one on the success container — so every call site
/// ends up restating the radius, the border and the ink well. This states them
/// once.
///
/// Separation here is a one pixel outline and a change of surface tone, never a
/// shadow. The only things in this design that sit on a shadow are the ones a
/// finger presses, and a card that borrowed the effect would look pressable
/// when it is not.
///
/// [color] defaults to the surface, [padding] to the inner step the design
/// uses, and [border] to the hairline — pass one in the reward or success
/// colour for a card that has to announce its state. [onTap] makes the whole
/// card the target, which is the only way a card meets the 44 pixel minimum
/// without every child having to.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.border,
    this.radius = AppRadii.xxl,
    this.onTap,
    super.key,
  });

  final Widget child;

  final Color? color;

  final EdgeInsetsGeometry padding;

  final BorderSide? border;

  final double radius;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final BorderRadius corner = BorderRadius.circular(radius);

    return Material(
      color: color ?? palette.surface,
      elevation: ValueConstants.zeroDouble,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: corner,
        side:
            border ??
            BorderSide(color: palette.outline, width: AppSizes.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
