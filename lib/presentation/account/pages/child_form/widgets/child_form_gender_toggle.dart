import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_gender_enum.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_form/items/child_form_gender_segment.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';

/// The two catalogue tabs, as one pill with the chosen half lifted.
///
/// It filters the faces below it and nothing else; [selected] is the tab
/// showing and [onChanged] switches it.
class ChildFormGenderToggle extends StatelessWidget {
  const ChildFormGenderToggle({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final AvatarGenderEnum selected;

  final ValueChanged<AvatarGenderEnum> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppPalette.of(context).surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadii.round),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final AvatarGenderEnum gender in AvatarGenderEnum.values)
            ChildFormGenderSegment(
              gender: gender,
              isSelected: gender == selected,
              onTap: () => onChanged(gender),
            ),
        ],
      ),
    );
  }
}
