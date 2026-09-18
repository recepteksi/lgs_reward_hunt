import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';

/// The way into the parent's side of the app.
///
/// A round shield in the middle of the navigation bar, riding above it. It is
/// not a fifth tab: the parent's screens are a different person's app, and
/// giving them a tab would put an adult's tools in the middle of a child's
/// navigation, where they would be tapped by accident and would make the app
/// feel supervised rather than owned.
///
/// It sits on the same solid edge as a primary button and carries a ring of the
/// surface colour around it, which is what lets it overlap the bar without
/// looking stuck to it.
///
/// [onPressed] opens the parent flow — behind a PIN, which is the flow's
/// business and not this button's.
class AppParentButton extends StatelessWidget {
  const AppParentButton({
    required this.semanticLabel,
    required this.onPressed,
    super.key,
  });

  final String semanticLabel;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: AppSizes.fab,
          height: AppSizes.fab,
          decoration: BoxDecoration(
            color: palette.primary,
            shape: BoxShape.circle,
            border: Border.all(
              color: palette.surface,
              width: AppSizes.fabBorder,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.primaryEdge,
                offset: const Offset(
                  ValueConstants.zeroDouble,
                  AppSizes.edgeDepth,
                ),
              ),
              BoxShadow(
                color: palette.primaryShadow,
                offset: const Offset(
                  ValueConstants.zeroDouble,
                  AppSizes.glowOffset,
                ),
                blurRadius: AppSizes.glowBlur,
              ),
            ],
          ),
          child: Center(
            child: AppIcon(
              AppIcons.shield,
              color: palette.onPrimary,
              size: AppSizes.iconSizeLarge,
            ),
          ),
        ),
      ),
    );
  }
}
