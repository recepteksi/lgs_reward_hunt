import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/household_read_model.dart';
import 'package:lgs_reward_hunt/domain/account/rules/account_rules.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_setup/items/child_setup_child_row.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_setup/widgets/child_setup_limit_note.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_setup/widgets/child_setup_parent_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_dashed_add_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_header.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_step_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The child setup step's one body: whose household it is, and who is in it.
///
/// The parent's card leads, so the parent can see which account the children
/// are going into before adding one. Below the list sits either the dashed add
/// button or, once the household is full, the note saying why there is no
/// button — a control that simply vanished would read as a bug.
///
/// The primary action cannot be pressed with nobody added, and its words say
/// what is missing rather than staying "Devam" and doing nothing. [onAdd],
/// [onRemove] and [onContinue] are the screen's to decide.
class ChildSetupBody extends StatelessWidget {
  const ChildSetupBody({
    required this.household,
    required this.onAdd,
    required this.onRemove,
    required this.onContinue,
    super.key,
  });

  final HouseholdReadModel household;

  final VoidCallback onAdd;

  final ValueChanged<String> onRemove;

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const AppSetupHeader(step: AppSetupStepEnum.child),
        const SizedBox(height: AppSpacing.xl),
        Expanded(
          child: ListView(
            children: <Widget>[
              ChildSetupParentCard(
                parent: household.parent,
                via: l10n.childSetupParentVia,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppText(l10n.childSetupTitle, type: AppTextTypeEnum.heading),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                l10n.childSetupBody(AccountRules.maxChildren),
                type: AppTextTypeEnum.body,
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final ChildEntity child in household.children) ...<Widget>[
                ChildSetupChildRow(
                  child: child,
                  avatar: household.avatarOf(child),
                  onRemove: () => onRemove(child.id),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (household.canAddChild)
                AppDashedAddButton(label: l10n.childSetupAdd, onPressed: onAdd)
              else
                const ChildSetupLimitNote(),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton.filled(
          label: household.hasChild
              ? l10n.commonContinue
              : l10n.childSetupNeedOne,
          isExpanded: true,
          onPressed: household.hasChild ? onContinue : null,
        ),
      ],
    );
  }
}
