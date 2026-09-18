import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One numbered section of the kit: a rank, a name, and what it is for.
///
/// Numbered because the sheet is read in order and referred to by number in
/// review — "03 is wrong on dark" is a sentence someone can act on, where "the
/// buttons bit" is not. The number is set in the primary so the eye can run
/// down the left edge and find a section without reading any of them.
///
/// [index] is the section's rank, [title] its name, [hint] the one line saying
/// what rule governs it, and [child] the specimens themselves.
class UiKitSection extends StatelessWidget {
  const UiKitSection({
    required this.index,
    required this.title,
    required this.hint,
    required this.child,
    super.key,
  });

  final int index;

  final String title;

  final String hint;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppPalette palette = AppPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            AppText(
              index.toString().padLeft(
                ValueConstants.two,
                CharConstants.zeroDigit,
              ),
              type: AppTextTypeEnum.badge,
              color: palette.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppText(
                title,
                type: AppTextTypeEnum.title,
                style: TextStyle(
                  fontSize: theme.textTheme.headlineSmall?.fontSize,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        AppText(hint, type: AppTextTypeEnum.meta),
        const SizedBox(height: AppSpacing.md),
        child,
      ],
    );
  }
}
