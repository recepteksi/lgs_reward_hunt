import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button_variant_enum.dart';

/// The colours and the edge one variant paints with.
///
/// Resolved in one place so that a variant is a row in [resolve] rather than a
/// branch inside the build method — adding the seventh button the design does
/// not have should mean editing a table, and noticing that it is a table.
class AppButtonStyle {
  const AppButtonStyle({
    required this.background,
    required this.foreground,
    this.edge,
    this.glow,
    this.border,
  });

  static AppButtonStyle resolve(
    AppButtonVariantEnum variant,
    AppPalette palette, {
    required bool isEnabled,
  }) {
    if (!isEnabled) {
      return AppButtonStyle(
        background: palette.outline,
        foreground: palette.onSurfaceMuted,
        edge: palette.outlineStrong,
      );
    }

    return switch (variant) {
      AppButtonVariantEnum.filled => AppButtonStyle(
        background: palette.primary,
        foreground: palette.onPrimary,
        edge: palette.primaryEdge,
        glow: palette.primaryShadow,
      ),
      AppButtonVariantEnum.reward => AppButtonStyle(
        background: palette.reward,
        foreground: palette.onReward,
        edge: palette.rewardEdge,
        glow: palette.rewardShadow,
      ),
      AppButtonVariantEnum.tonal => AppButtonStyle(
        background: palette.primaryContainer,
        foreground: palette.onPrimaryContainer,
      ),
      AppButtonVariantEnum.rewardTonal => AppButtonStyle(
        background: palette.rewardSoft,
        foreground: palette.rewardInk,
        border: Border.all(color: palette.reward, width: AppSizes.borderStrong),
      ),
      AppButtonVariantEnum.outlined => AppButtonStyle(
        background: Colors.transparent,
        foreground: palette.primary,
        border: Border.all(
          color: palette.outlineStrong,
          width: AppSizes.borderThick,
        ),
      ),
      AppButtonVariantEnum.errorOutlined => AppButtonStyle(
        background: Colors.transparent,
        foreground: palette.errorInk,
        border: Border.all(
          color: palette.errorInk,
          width: AppSizes.borderThick,
        ),
      ),
      AppButtonVariantEnum.text => AppButtonStyle(
        background: Colors.transparent,
        foreground: palette.primary,
      ),
    };
  }

  final Color background;

  final Color foreground;

  final Color? edge;

  final Color? glow;

  final Border? border;

  List<BoxShadow> shadows({required bool isDown}) {
    final Color? edge = this.edge;
    final Color? glow = this.glow;

    if (edge == null) {
      return const <BoxShadow>[];
    }

    return <BoxShadow>[
      BoxShadow(
        color: edge,
        offset: Offset(
          ValueConstants.zeroDouble,
          isDown ? AppSizes.edgePressed : AppSizes.edgeDepth,
        ),
      ),
      if (glow != null && !isDown)
        BoxShadow(
          color: glow,
          offset: const Offset(ValueConstants.zeroDouble, AppSizes.glowOffset),
          blurRadius: AppSizes.glowBlur,
        ),
    ];
  }
}
