import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/device_choice_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/session/pages/device_child/items/device_child_row.dart';

/// The device step's one body: the question, the children, and a note.
///
/// Each child is one full-width button — the whole row is the choice, there is
/// no separate confirm, because the next thing the parent does after picking
/// is hand the phone over. The device's current child is outlined.
/// [choice] is what to show and [onChoose] takes the picked child's id.
class DeviceChildBody extends StatelessWidget {
  const DeviceChildBody({
    required this.choice,
    required this.onChoose,
    super.key,
  });

  final DeviceChoiceReadModel choice;

  final ValueChanged<String> onChoose;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              AppText(l10n.deviceChildTitle, type: AppTextTypeEnum.heading),
              const SizedBox(height: AppSpacing.sm),
              AppText(l10n.deviceChildBody, type: AppTextTypeEnum.body),
              const SizedBox(height: AppSpacing.xl),
              for (final ChildEntity child
                  in choice.household.children) ...<Widget>[
                DeviceChildRow(
                  child: child,
                  avatar: choice.household.avatarOf(child),
                  balance: choice.balanceOf(child),
                  isActive: choice.isActive(child),
                  onTap: () => onChoose(child.id),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppText(
          l10n.deviceChildNote,
          type: AppTextTypeEnum.caption,
          color: AppPalette.of(context).onSurfaceMuted,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
