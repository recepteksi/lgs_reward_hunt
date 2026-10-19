import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/profile/read_models/profile_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_opacity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/level_rank_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/avatar/app_avatar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The child, large, on the primary colour: face, name, grade, level and rank.
///
/// The one card on the tab in the accent's full colour, because it is the
/// child — the thing the accent was chosen to feel like theirs. [profile]
/// supplies all of it.
class ProfileChildCard extends StatelessWidget {
  const ProfileChildCard({required this.profile, super.key});

  static const double _face = 66;

  final ProfileReadModel profile;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: palette.primary,
        borderRadius: BorderRadius.circular(AppRadii.xxxl),
      ),
      child: Row(
        children: <Widget>[
          AppAvatar(avatar: profile.header.avatar, size: _face),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  profile.header.child.name,
                  type: AppTextTypeEnum.balance,
                  color: palette.onPrimary,
                  weight: FontWeight.w900,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText(
                  l10n.profileChildLine(
                    profile.header.child.gradeLevel,
                    profile.progress.level,
                    levelRankCopy(l10n, profile.progress.rank),
                  ),
                  type: AppTextTypeEnum.meta,
                  color: palette.onPrimary.withValues(
                    alpha: AppOpacity.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
