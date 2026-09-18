import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/study_path/read_models/study_stop_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// What the day sheet shows for a day that has not opened: a lock, and what
/// the day will hold.
///
/// The tasks themselves are not listed — a future day's plan still changes —
/// but their count and worth are, because a child deciding whether tomorrow is
/// a heavy day is planning, which is the habit the map is for. [stop] is the
/// day.
class HomeLockedDayCard extends StatelessWidget {
  const HomeLockedDayCard({required this.stop, super.key});

  static const double _lockTile = 40;

  final StudyStopReadModel stop;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: _lockTile,
            height: _lockTile,
            decoration: BoxDecoration(
              color: palette.outline,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppIcon(
                AppIcons.locked,
                color: palette.onSurfaceMuted,
                size: AppSizes.iconSizeMedium,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppText(
            l10n.mapLockedTitle,
            type: AppTextTypeEnum.body,
            weight: FontWeight.w800,
            color: palette.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(
            l10n.mapLockedHint(stop.tasks.length, stop.totalPoints),
            type: AppTextTypeEnum.meta,
            color: palette.onSurfaceMuted,
          ),
        ],
      ),
    );
  }
}
