import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';

/// Every role a piece of text can play, and the only way to ask for a style.
///
/// A widget names what the text IS — a [heading], a [meta] line, a [balance] —
/// and never which `TextTheme` slot carries it. That indirection is the whole
/// point: `titleSmall` is Material's word, not this product's, and a screen
/// written against it cannot be read by anyone who has not memorised which of
/// Material's fifteen slots this design actually uses.
///
/// [display] is the countdown and the balance on its own screen; [balance] the
/// same figure worn as a pill in a bar; [cost] a price on a reward's card.
/// [heading] titles a screen, [title] a card, [button] every control's label.
/// [body] is a sentence, [badge] a figure inside a pill, [meta] the line under
/// a task's name, [caption] the smallest thing still meant to be read, and
/// [label] the tracked capitals over a section — the one role that is never a
/// sentence.
///
/// [resolve] is where a role becomes a style. It reads the theme rather than
/// building one, so a change in `AppTheme` reaches every piece of text in the
/// app and nothing here has to be edited.
enum AppTextTypeEnum {
  display,
  balance,
  cost,
  heading,
  title,
  button,
  body,
  badge,
  meta,
  caption,
  label;

  TextStyle? resolve(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return switch (this) {
      AppTextTypeEnum.display => text.displayMedium,
      AppTextTypeEnum.balance => text.titleSmall?.copyWith(
        fontSize: AppTypography.balance,
      ),
      AppTextTypeEnum.cost => text.titleSmall?.copyWith(
        fontSize: AppTypography.cost,
      ),
      AppTextTypeEnum.heading => text.headlineSmall,
      AppTextTypeEnum.title => text.titleMedium,
      AppTextTypeEnum.button => text.labelLarge,
      AppTextTypeEnum.body => text.bodyMedium,
      AppTextTypeEnum.badge => text.titleSmall,
      AppTextTypeEnum.meta => text.bodySmall,
      AppTextTypeEnum.caption => text.labelMedium,
      AppTextTypeEnum.label => text.labelSmall,
    };
  }
}
