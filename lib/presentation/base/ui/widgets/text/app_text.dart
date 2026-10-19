import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The only way this app draws words.
///
/// A bare `Text` takes whatever style the tree happens to hand it, which is how
/// two screens end up with the same sentence at two sizes. [AppText] asks for a
/// ROLE instead — `AppTextTypeEnum.meta`, `AppTextTypeEnum.heading` — and the
/// theme answers, so the type scale is enforced by the compiler's insistence on
/// a value rather than by everyone remembering it.
///
/// The role is the starting point, not a cage. [color] and [weight] are the two
/// things a call site legitimately varies — the same body text in the error ink
/// or a title in a heavier weight — and [style] is the escape hatch for the
/// rest, merged over the role rather than replacing it, so a caller changing
/// one property does not silently lose the family, the tracking and the line
/// height that came with it.
///
/// [text] is the words, already localized. [maxLines], [textAlign] and
/// [overflow] are `Text`'s own, passed through because a role says nothing
/// about how many lines a layout can spare.
class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    required this.type,
    this.color,
    this.weight,
    this.style,
    this.maxLines,
    this.textAlign,
    this.overflow,
    super.key,
  });

  final String text;

  final AppTextTypeEnum type;

  final Color? color;

  final FontWeight? weight;

  final TextStyle? style;

  final int? maxLines;

  final TextAlign? textAlign;

  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: type
          .resolve(context)
          ?.copyWith(color: color, fontWeight: weight)
          .merge(style),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
