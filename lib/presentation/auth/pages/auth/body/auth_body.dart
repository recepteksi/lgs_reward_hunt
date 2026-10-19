import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/auth/auth_cubit.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/enums/auth_provider_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_chip.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_text_field.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_header.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_step_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The account form, in whichever of its two modes is showing.
///
/// It keeps its own controllers, which is what a form is: text being typed is
/// not application state, and pushing every keystroke through a Cubit would
/// rebuild the screen for nothing. What the Cubit hears about is the submit.
///
/// Google and Apple sit above the email form, as the design has them. Apple is
/// offered on Apple's own platforms, where the App Store requires it beside any
/// other platform sign-in and where it needs no web redirect; on Android the
/// Google button stands alone.
///
/// [failure] is shown under the fields rather than as a card over them: the
/// parent's next move is to fix a field, and a card would cover the fields.
class AuthBody extends StatefulWidget {
  const AuthBody({required this.isSignUp, this.failure, super.key});

  final bool isSignUp;

  final Failure? failure;

  @override
  State<AuthBody> createState() => _AuthBodyState();
}

/// Holds what is being typed.
class _AuthBodyState extends State<AuthBody> {
  bool get _offersApple =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  final TextEditingController _name = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final AuthCubit cubit = context.read<AuthCubit>();
    final Failure? failure = widget.failure;

    return ListView(
      children: <Widget>[
        const AppSetupHeader(step: AppSetupStepEnum.account),
        const SizedBox(height: AppSpacing.xl),
        AppText(l10n.authTitle, type: AppTextTypeEnum.heading),
        const SizedBox(height: AppSpacing.sm),
        AppText(l10n.authBody, type: AppTextTypeEnum.body),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: <Widget>[
            AppChip(
              label: l10n.authTabSignUp,
              isSelected: widget.isSignUp,
              onTap: cubit.chooseSignUp,
            ),
            const SizedBox(width: AppSpacing.sm),
            AppChip(
              label: l10n.authTabSignIn,
              isSelected: !widget.isSignUp,
              onTap: cubit.chooseSignIn,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.outlined(
          label: l10n.authContinueGoogle,
          icon: AppIcons.google,
          isExpanded: true,
          onPressed: () => cubit.continueWith(AuthProviderEnum.google),
        ),
        if (_offersApple) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          AppButton.filled(
            label: l10n.authContinueApple,
            icon: AppIcons.apple,
            isExpanded: true,
            onPressed: () => cubit.continueWith(AuthProviderEnum.apple),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: <Widget>[
            Expanded(
              child: Divider(height: AppSizes.border, color: palette.outline),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: AppText(l10n.authOrEmail, type: AppTextTypeEnum.caption),
            ),
            Expanded(
              child: Divider(height: AppSizes.border, color: palette.outline),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        if (widget.isSignUp) ...<Widget>[
          AppTextField(
            label: l10n.fieldFullName,
            hint: l10n.fieldFullNameHint,
            controller: _name,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        AppTextField(
          label: l10n.fieldEmail,
          hint: l10n.fieldEmailHint,
          controller: _email,
          keyboardType: TextInputType.emailAddress,
        ),
        if (!widget.isSignUp) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: l10n.fieldPassword,
            hint: l10n.fieldPasswordHint,
            controller: _password,
            obscure: true,
          ),
        ],
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
          label: widget.isSignUp ? l10n.introCreateAccount : l10n.authTabSignIn,
          isExpanded: true,
          onPressed: () => _submit(cubit),
        ),
        const SizedBox(height: AppSpacing.md),
        AppText(
          l10n.authTerms,
          type: AppTextTypeEnum.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _submit(AuthCubit cubit) {
    if (widget.isSignUp) {
      cubit.submitSignUp(name: _name.text.trim(), email: _email.text.trim());
      return;
    }

    cubit.submitSignIn(email: _email.text.trim(), password: _password.text);
  }
}
