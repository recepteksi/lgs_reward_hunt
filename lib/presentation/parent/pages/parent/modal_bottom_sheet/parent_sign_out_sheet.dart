import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// Asks once before signing the parent out.
///
/// The button that opens it sits next to "Çık", and signing out means signing
/// in again, so one stray tap should not do it. The sheet closes before
/// [onConfirm] runs.
class ParentSignOutSheet extends StatelessWidget {
  const ParentSignOutSheet({required this.onConfirm, super.key});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppText(
            l10n.parentSignOutTitle,
            type: AppTextTypeEnum.title,
            weight: FontWeight.w900,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            l10n.parentSignOutBody,
            type: AppTextTypeEnum.body,
            color: AppPalette.of(context).onSurfaceMuted,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton.errorOutlined(
            label: l10n.parentSignOut,
            isExpanded: true,
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton.text(
            label: l10n.commonCancel,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
