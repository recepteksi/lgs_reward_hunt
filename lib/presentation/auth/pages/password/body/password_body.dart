import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/password/password_cubit.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/enums/password_rule_enum.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/password/widgets/password_rule_row.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_text_field.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_header.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_step_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/router/arguments/password_arguments_model.dart';

/// The password, its repeat, and the three rules ticking as they are met.
///
/// The checklist is not decoration: it is the same [PasswordRuleEnum] the
/// domain refuses a password on, rendered. A parent should never press a button
/// and be told afterwards what the rules were.
///
/// The button stays disabled until every rule is met and the two fields agree,
/// which is why this widget rebuilds on each keystroke — the state is small and
/// local, and the alternative is a parent submitting into a refusal.
class PasswordBody extends StatefulWidget {
  const PasswordBody({required this.arguments, this.failure, super.key});

  final PasswordArgumentsModel arguments;

  final Failure? failure;

  @override
  State<PasswordBody> createState() => _PasswordBodyState();
}

/// Holds what is being typed, and whether it is shown.
class _PasswordBodyState extends State<PasswordBody> {
  final TextEditingController _password = TextEditingController();

  final TextEditingController _repeat = TextEditingController();

  bool _isVisible = false;

  @override
  void dispose() {
    _password.dispose();
    _repeat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final Failure? failure = widget.failure;
    final bool matches = _repeat.text.isEmpty || _password.text == _repeat.text;
    final bool canSubmit =
        PasswordRuleEnum.allMetBy(_password.text) &&
        _password.text == _repeat.text;

    return ListView(
      children: <Widget>[
        const AppSetupHeader(step: AppSetupStepEnum.password),
        const SizedBox(height: AppSpacing.xl),
        AppText(l10n.passwordTitle, type: AppTextTypeEnum.heading),
        const SizedBox(height: AppSpacing.sm),
        AppText(l10n.passwordBody, type: AppTextTypeEnum.body),
        const SizedBox(height: AppSpacing.xl),
        AppTextField(
          label: l10n.fieldPassword,
          controller: _password,
          obscure: !_isVisible,
          onChanged: (_) => setState(() {}),
          trailing: GestureDetector(
            onTap: () => setState(() => _isVisible = !_isVisible),
            child: AppText(
              _isVisible ? l10n.passwordHide : l10n.passwordShow,
              type: AppTextTypeEnum.label,
              color: palette.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final PasswordRuleEnum rule in PasswordRuleEnum.values)
          PasswordRuleRow(rule: rule, isMet: rule.isMetBy(_password.text)),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: l10n.fieldPasswordRepeat,
          controller: _repeat,
          obscure: !_isVisible,
          onChanged: (_) => setState(() {}),
          error: matches ? null : l10n.passwordMismatch,
        ),
        if (failure != null) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          AppText(
            failureCopy(l10n, failure),
            type: AppTextTypeEnum.caption,
            color: palette.errorInk,
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        AppButton.filled(
          label: l10n.commonContinue,
          isExpanded: true,
          onPressed: canSubmit
              ? () => context.read<PasswordCubit>().submit(
                  name: widget.arguments.name,
                  email: widget.arguments.email,
                  password: _password.text,
                )
              : null,
        ),
      ],
    );
  }
}
