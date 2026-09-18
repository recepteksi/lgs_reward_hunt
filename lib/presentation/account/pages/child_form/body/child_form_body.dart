import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/account/cubit/child_form/child_form_cubit.dart';
import 'package:lgs_reward_hunt/domain/account/rules/account_rules.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/enums/avatar_gender_enum.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_form/widgets/child_form_avatar_catalog.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_form/widgets/child_form_gender_toggle.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_option_tile.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_text_field.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The child form's one body.
///
/// It keeps what is being typed and tapped — the name, the grade, the
/// catalogue tab, the chosen face — the way `AuthBody` keeps its controllers:
/// none of it is application state until the parent presses save. The chosen
/// face survives switching tabs, so a parent who looks at the other tab and
/// comes back finds their choice where they left it.
///
/// The button cannot be pressed until there is a name and a face, and not
/// while [state] is saving. A refused save shows its reason above the button,
/// where the eye already is. The way back is the page's app bar.
class ChildFormBody extends StatefulWidget {
  const ChildFormBody({required this.state, super.key});

  final ChildFormState state;

  @override
  State<ChildFormBody> createState() => _ChildFormBodyState();
}

/// Holds the form's draft.
class _ChildFormBodyState extends State<ChildFormBody> {
  final TextEditingController _name = TextEditingController();

  int _grade = AccountRules.defaultGradeLevel;

  AvatarGenderEnum _gender = AvatarGenderEnum.fallback;

  AvatarEntity? _avatar;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final ChildFormState state = widget.state;
    final AvatarEntity? avatar = _avatar;
    final bool isSaving = state is ChildFormSaving;
    final bool canSave =
        !isSaving && _name.text.trim().isNotEmpty && avatar != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              AppText(l10n.childFormTitle, type: AppTextTypeEnum.heading),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                label: l10n.childFormName,
                hint: l10n.childFormNameHint,
                controller: _name,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppText(l10n.childFormGrade, type: AppTextTypeEnum.label),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: <Widget>[
                  for (final int grade in AccountRules.gradeLevels) ...<Widget>[
                    if (grade != AccountRules.gradeLevels.first)
                      const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppOptionTile(
                        label: l10n.childFormGradeOption(grade),
                        isSelected: grade == _grade,
                        onTap: () => setState(() => _grade = grade),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: <Widget>[
                  Expanded(
                    child: AppText(
                      l10n.childFormAvatar,
                      type: AppTextTypeEnum.label,
                    ),
                  ),
                  ChildFormGenderToggle(
                    selected: _gender,
                    onChanged: (AvatarGenderEnum gender) =>
                        setState(() => _gender = gender),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ChildFormAvatarCatalog(
                state: state,
                gender: _gender,
                selectedId: avatar?.id,
                onPick: (AvatarEntity picked) =>
                    setState(() => _avatar = picked),
                onRetry: context.read<ChildFormCubit>().loadAvatars,
              ),
            ],
          ),
        ),
        if (state case ChildFormSaveFailed(:final failure)) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          AppText(
            failureCopy(l10n, failure),
            type: AppTextTypeEnum.caption,
            color: palette.errorInk,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppButton.filled(
          label: l10n.childFormSave,
          isExpanded: true,
          onPressed: canSave
              ? () => context.read<ChildFormCubit>().save(
                  name: _name.text,
                  gradeLevel: _grade,
                  avatarId: avatar.id,
                )
              : null,
        ),
      ],
    );
  }
}
