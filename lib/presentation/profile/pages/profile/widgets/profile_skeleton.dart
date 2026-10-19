import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_header_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_typography.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/avatar/app_avatar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_settings_row.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_shimmer.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/profile/pages/profile/widgets/profile_appearance_card.dart';

/// The profile before its numbers have loaded — mostly not a skeleton at all.
///
/// A student opening their profile should not wait for what is already
/// known: the heading, the appearance setting and the way into parent mode are
/// real straight away, and the child card is real whenever [header] is known.
/// Only the stats and the rows that need a load — the exam date, the linked
/// parent — shimmer. [onParentMode] opens the PIN gate, as on the loaded page.
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({
    required this.header,
    required this.onParentMode,
    super.key,
  });

  static const double _face = 66;

  static const double _nameWidth = 110;

  static const double _lineWidth = 150;

  static const double _valueWidth = 72;

  static const int _stats = 3;

  final ChildHeaderReadModel? header;

  final VoidCallback onParentMode;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final ChildHeaderReadModel? header = this.header;

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
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: palette.primary,
            borderRadius: BorderRadius.circular(AppRadii.xxxl),
          ),
          child: header == null
              ? const AppShimmer(
                  child: Row(
                    children: <Widget>[
                      AppSkeleton.circle(size: _face),
                      SizedBox(width: AppSpacing.lg),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AppSkeleton.line(
                            width: _nameWidth,
                            size: AppTypography.balance,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          AppSkeleton.line(
                            width: _lineWidth,
                            size: AppTypography.meta,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Row(
                  children: <Widget>[
                    AppAvatar(avatar: header.avatar, size: _face),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AppText(
                            header.child.name,
                            type: AppTextTypeEnum.balance,
                            color: palette.onPrimary,
                            weight: FontWeight.w900,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          AppText(
                            l10n.childGrade(header.child.gradeLevel),
                            type: AppTextTypeEnum.meta,
                            color: palette.onPrimarySoft,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: <Widget>[
            for (int i = ValueConstants.zero; i < _stats; i++) ...<Widget>[
              if (i > ValueConstants.zero) const SizedBox(width: AppSpacing.sm),
              const Expanded(
                child: AppCard(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: AppShimmer(
                    child: Column(
                      children: <Widget>[
                        AppSkeleton.line(
                          width: _valueWidth / ValueConstants.two,
                          size: AppTypography.heading,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        AppSkeleton.line(
                          width: _valueWidth,
                          size: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                trailing: const AppShimmer(
                  child: AppSkeleton.line(width: _valueWidth),
                ),
              ),
              Divider(height: AppSizes.border, color: palette.outline),
              AppSettingsRow(
                icon: AppIcons.shield,
                title: l10n.profileLinkedParent,
                trailing: const AppShimmer(
                  child: AppSkeleton.line(width: _valueWidth),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
