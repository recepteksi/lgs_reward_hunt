import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/auth/enums/password_rule_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/password_rule_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One line of the password checklist: a tick and what it stands for.
///
/// Met is the success colour on a filled circle; unmet is the neutral outline
/// rather than a red cross — a rule not yet satisfied is not a mistake, it is
/// the rest of the instruction.
class PasswordRuleRow extends StatelessWidget {
  const PasswordRuleRow({required this.rule, required this.isMet, super.key});

  static const double _dot = 20;

  final PasswordRuleEnum rule;

  final bool isMet;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: <Widget>[
          Container(
            width: _dot,
            height: _dot,
            decoration: BoxDecoration(
              color: isMet ? palette.success : palette.surfaceHigh,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppIcon(
                AppIcons.check,
                color: isMet ? palette.surface : palette.outlineStrong,
                size: AppSizes.iconSizeSmall,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppText(
            passwordRuleCopy(AppL10n.of(context), rule),
            type: AppTextTypeEnum.caption,
            color: isMet ? palette.onSurface : palette.onSurfaceMuted,
          ),
        ],
      ),
    );
  }
}
