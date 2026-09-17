import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/radix_constants.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One colour token: the colour itself, its name, and the value it came out as.
///
/// The hex is shown because the palette is DERIVED — nobody typed these, they
/// fell out of three seeds — so the only way to know what the pink accent's
/// `surfaceHigh` actually is, is to read it off a running app. That is also why
/// the swatch reads the colour it was handed rather than looking it up: the
/// same widget serves all five accents in both brightnesses.
///
/// [name] is the token's name in [AppPalette] and [color] its current value.
class UiKitSwatch extends StatelessWidget {
  const UiKitSwatch({required this.name, required this.color, super.key});

  static const double _height = 52;

  static const int _argbDigits = 8;

  static const int _alphaDigits = 2;

  static const String _hexPrefix = '#';

  final String name;

  final Color color;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: _height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadii.sm),
            border: Border.all(color: palette.outline, width: AppSizes.border),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppText(
          name,
          type: AppTextTypeEnum.caption,
          weight: FontWeight.w900,
          color: palette.onSurface,
          maxLines: ValueConstants.one,
          overflow: TextOverflow.ellipsis,
        ),
        AppText(
          _hex(color),
          type: AppTextTypeEnum.label,
          style: const TextStyle(letterSpacing: ValueConstants.zeroDouble),
        ),
      ],
    );
  }

  String _hex(Color color) {
    final String value = color
        .toARGB32()
        .toRadixString(RadixConstants.hexadecimal)
        .padLeft(_argbDigits, CharConstants.zeroDigit)
        .toUpperCase();

    return '$_hexPrefix${value.substring(_alphaDigits)}';
  }
}
