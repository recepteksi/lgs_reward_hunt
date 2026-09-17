import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The tracked capitals that name a group inside a section.
///
/// The design system's smallest type role, and the only one that is never a
/// sentence: "FILLED · PRIMARY ACTION", "POINTS · SMALL / LARGE". It labels a
/// specimen rather than speaking to a user, which is why it is set in the
/// widest tracking in the scale — at ten pixels, letter spacing is what makes
/// capitals legible instead of a smudge.
class UiKitCaption extends StatelessWidget {
  const UiKitCaption(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppText(text.toUpperCase(), type: AppTextTypeEnum.label);
  }
}
