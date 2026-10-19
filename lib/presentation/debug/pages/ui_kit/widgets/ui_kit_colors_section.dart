import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/items/ui_kit_swatch.dart';

/// Section 01: the twenty tokens a screen is actually built out of.
///
/// Not the whole palette — the forty-odd it derives include shadows and map
/// textures nobody reads as a colour. These twenty are the ones a component
/// picks between, listed in the order the design system lists them: the brand
/// first, then the currency, then the two signal colours, then the neutrals
/// that carry everything else, then the map.
///
/// They are read from the live [AppPalette], so the grid re-derives itself when
/// the accent above it changes. That is the point of showing them at all: the
/// values are computed, and the only way to see the pink theme's `surfaceHigh`
/// is to ask the running app for it.
class UiKitColorsSection extends StatelessWidget {
  const UiKitColorsSection({super.key});

  static const int _columns = 3;

  static const double _aspectRatio = 1.05;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final Map<String, Color> tokens = <String, Color>{
      'primary': palette.primary,
      'primaryContainer': palette.primaryContainer,
      'onPrimaryContainer': palette.onPrimaryContainer,
      'reward': palette.reward,
      'rewardSoft': palette.rewardSoft,
      'onReward': palette.onReward,
      'rewardInk': palette.rewardInk,
      'success': palette.success,
      'error': palette.error,
      'background': palette.background,
      'surface': palette.surface,
      'surfaceHigh': palette.surfaceHigh,
      'outline': palette.outline,
      'outlineStrong': palette.outlineStrong,
      'onSurface': palette.onSurface,
      'onSurfaceVariant': palette.onSurfaceVariant,
      'onSurfaceMuted': palette.onSurfaceMuted,
      'mapBase': palette.mapBase,
      'mapLocked': palette.mapLocked,
      'mapEdge': palette.mapEdge,
    };

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: _columns,
      crossAxisSpacing: AppSpacing.sm,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: _aspectRatio,
      children: <Widget>[
        for (final MapEntry<String, Color> token in tokens.entries)
          UiKitSwatch(name: token.key, color: token.value),
      ],
    );
  }
}
