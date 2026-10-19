import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The heading above a list, with the line that belongs beside it.
///
/// The two are one widget because they are one sentence: "this week" and "4 of
/// 7 days" answer each other, and a screen that lays each of them out again
/// ends up with the count above the heading on one of them.
///
/// [title] is the heading. [trailing] is the quiet half — a count, a total, a
/// date — and is optional, because most sections have nothing to say beside
/// their name.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({required this.title, this.trailing, super.key});

  final String title;

  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final String? trailing = this.trailing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(child: AppText(title, type: AppTextTypeEnum.heading)),
        if (trailing != null) ...<Widget>[
          const SizedBox(width: AppSpacing.md),
          AppText(
            trailing,
            type: AppTextTypeEnum.meta,
            weight: FontWeight.w800,
            color: palette.onSurfaceVariant,
          ),
        ],
      ],
    );
  }
}
