import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/badge/app_status_tone_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// Where a request or a reward has got to, as a pill.
///
/// One widget with four named constructors rather than four widgets, because
/// the four states are one vocabulary: a screen that invents a fifth is the
/// screen where "waiting" and "pending" start meaning different things to the
/// same reader.
///
/// [AppStatusBadge.pending] is the reward colour, because waiting for a
/// parent's approval belongs to the economy rather than to the system.
/// [AppStatusBadge.approved] is the earned green and [AppStatusBadge.rejected]
/// the softest red in the palette — a refusal from a parent is an answer, not
/// an error, and it is followed by a note explaining it.
/// [AppStatusBadge.locked] is neutral and usually carries what is still
/// missing, because a reward out of reach is shown rather than hidden.
///
/// [label] is the words, already localized — a badge does not choose copy.
class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge.pending({required this.label, super.key})
    : _tone = AppStatusToneEnum.pending;

  const AppStatusBadge.approved({required this.label, super.key})
    : _tone = AppStatusToneEnum.approved;

  const AppStatusBadge.rejected({required this.label, super.key})
    : _tone = AppStatusToneEnum.rejected;

  const AppStatusBadge.locked({required this.label, super.key})
    : _tone = AppStatusToneEnum.locked;

  final String label;

  final AppStatusToneEnum _tone;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    final Color background = switch (_tone) {
      AppStatusToneEnum.pending => palette.rewardContainer,
      AppStatusToneEnum.approved => palette.successContainer,
      AppStatusToneEnum.rejected => palette.errorContainer,
      AppStatusToneEnum.locked => palette.surfaceHigh,
    };
    final Color foreground = switch (_tone) {
      AppStatusToneEnum.pending => palette.rewardInk,
      AppStatusToneEnum.approved => palette.successInk,
      AppStatusToneEnum.rejected => palette.errorInk,
      AppStatusToneEnum.locked => palette.onSurfaceMuted,
    };

    return Container(
      height: AppSizes.statusPill,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.round),
      ),
      child: AppText(
        label,
        type: AppTextTypeEnum.meta,
        color: foreground,
        weight: FontWeight.w800,
      ),
    );
  }
}
