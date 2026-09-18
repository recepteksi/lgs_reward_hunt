import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/account/rules/account_rules.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// What stands where the add button was, once the household is full.
///
/// A lock and a sentence on the high surface — quiet, because reaching the
/// limit is not a mistake, and specific, because a parent with a third child
/// needs to know there is a way.
class ChildSetupLimitNote extends StatelessWidget {
  const ChildSetupLimitNote({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: <Widget>[
          AppIcon(
            AppIcons.locked,
            color: palette.onSurfaceMuted,
            size: AppSizes.iconSizeMedium,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: AppText(
              AppL10n.of(context).childSetupLimit(AccountRules.maxChildren),
              type: AppTextTypeEnum.meta,
              color: palette.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
