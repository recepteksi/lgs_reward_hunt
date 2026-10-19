import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The twelve keys: nine digits, a gap, zero, and a backspace.
///
/// Its own keypad rather than the system keyboard, because the system one for a
/// four digit code covers half the screen, takes a moment to appear, and offers
/// autocorrect on a number. The gap in the bottom-left is deliberate — it keeps
/// zero under the thumb where it belongs.
class AppPinKeypad extends StatelessWidget {
  const AppPinKeypad({
    required this.onDigit,
    required this.onBackspace,
    super.key,
  });

  static const List<String> _keys = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    CharConstants.empty,
    '0',
    '⌫',
  ];

  static const String _backspace = '⌫';

  static const int _columns = 3;

  static const double _keyHeight = 64;

  static const double _aspect = 1.6;

  final ValueChanged<String> onDigit;

  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: _columns,
      childAspectRatio: _aspect,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      children: <Widget>[
        for (final String key in _keys)
          key.isEmpty
              ? const SizedBox(height: _keyHeight)
              : Material(
                  color: palette.surface,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    onTap: () =>
                        key == _backspace ? onBackspace() : onDigit(key),
                    child: Center(
                      child: AppText(
                        key,
                        type: AppTextTypeEnum.title,
                        color: palette.onSurface,
                      ),
                    ),
                  ),
                ),
      ],
    );
  }
}
