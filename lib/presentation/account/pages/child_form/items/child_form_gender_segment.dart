import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_gender_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/avatar_gender_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One half of the catalogue toggle.
///
/// The chosen half is the surface on the toggle's high ground, the other is
/// bare: the pill reads as a switch with a knob rather than as two buttons.
/// [gender] names the tab, [isSelected] lifts it and [onTap] chooses it.
class ChildFormGenderSegment extends StatelessWidget {
  const ChildFormGenderSegment({
    required this.gender,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final AvatarGenderEnum gender;

  final bool isSelected;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final String label = avatarGenderCopy(AppL10n.of(context), gender);

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: kThemeAnimationDuration,
          height: AppSizes.streakPill,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? palette.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadii.round),
          ),
          child: AppText(
            label,
            type: AppTextTypeEnum.badge,
            weight: FontWeight.w800,
            color: isSelected ? palette.onSurface : palette.onSurfaceMuted,
          ),
        ),
      ),
    );
  }
}
