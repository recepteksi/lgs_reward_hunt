import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_settings_row.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_error_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/profile/pages/profile/widgets/profile_appearance_card.dart';

/// The profile when its numbers could not be read.
///
/// Only the part that needed the server becomes a retry. The appearance
/// setting and the way into parent mode are on the device, so they stay: a
/// failing backend must not stop a student changing the theme, or a parent
/// reaching their side, where signing out is. [message] is the failure already
/// in words, [onRetry] loads again, and [onParentMode] opens the PIN gate.
class ProfileFailure extends StatelessWidget {
  const ProfileFailure({
    required this.message,
    required this.onRetry,
    required this.onParentMode,
    super.key,
  });

  final String message;

  final VoidCallback onRetry;

  final VoidCallback onParentMode;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxxl,
      ),
      children: <Widget>[
        AppText(l10n.profileTitle, type: AppTextTypeEnum.heading),
        const SizedBox(height: AppSpacing.md),
        AppErrorView(message: message, onRetry: onRetry),
        const SizedBox(height: AppSpacing.md),
        const ProfileAppearanceCard(),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          radius: AppRadii.xxxl,
          padding: EdgeInsets.zero,
          child: AppSettingsRow(
            icon: AppIcons.locked,
            title: l10n.profileParentMode,
            subtitle: l10n.profileParentModeBody,
            onTap: onParentMode,
          ),
        ),
      ],
    );
  }
}
