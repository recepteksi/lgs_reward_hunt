import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/domain/profile/read_models/profile_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_settings_row.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/profile/pages/profile/widgets/profile_appearance_card.dart';
import 'package:lgs_reward_hunt/presentation/profile/pages/profile/widgets/profile_child_card.dart';
import 'package:lgs_reward_hunt/presentation/profile/pages/profile/widgets/profile_stat_tile.dart';

/// The profile tab's one body, top to bottom in the design's order.
///
/// The settings list keeps only rows that are true: the parent mode door, the
/// exam date and the linked parent. The design's reminder row is left out —
/// there is no reminder behind it yet, and a row showing a time nothing uses
/// would be a promise the app does not keep. [profile] is what to show and
/// [onParentMode] opens the parent's side.
class ProfileBody extends StatelessWidget {
  const ProfileBody({required this.profile, this.onParentMode, super.key});

  final ProfileReadModel profile;

  final VoidCallback? onParentMode;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);

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
        ProfileChildCard(profile: profile),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            Expanded(
              child: ProfileStatTile(
                value: profile.progress.account.balance,
                label: l10n.profileStatPoints,
                ink: palette.rewardInk,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: ProfileStatTile(
                value: profile.progress.streakDays,
                label: l10n.profileStatStreak,
                ink: palette.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: ProfileStatTile(
                value: profile.progress.completedTaskCount,
                label: l10n.profileStatTasks,
                ink: palette.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const ProfileAppearanceCard(),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          radius: AppRadii.xxxl,
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              AppSettingsRow(
                icon: AppIcons.locked,
                title: l10n.profileParentMode,
                subtitle: l10n.profileParentModeBody,
                onTap: onParentMode,
              ),
              Divider(height: AppSizes.border, color: palette.outline),
              AppSettingsRow(
                icon: AppIcons.clock,
                title: l10n.profileExamDate,
                trailing: AppText(
                  DateFormat.yMMMMd(
                    Localizations.localeOf(context).toLanguageTag(),
                  ).format(profile.examDate),
                  type: AppTextTypeEnum.meta,
                  color: palette.onSurfaceMuted,
                ),
              ),
              Divider(height: AppSizes.border, color: palette.outline),
              AppSettingsRow(
                icon: AppIcons.shield,
                title: l10n.profileLinkedParent,
                trailing: AppText(
                  profile.parent.name,
                  type: AppTextTypeEnum.meta,
                  color: palette.onSurfaceMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
