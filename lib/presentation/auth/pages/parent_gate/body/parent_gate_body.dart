import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/parent_gate/parent_gate_cubit.dart';
import 'package:lgs_reward_hunt/domain/auth/rules/auth_rules.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_pin_dots.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_pin_keypad.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_fill_scroll_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The gate's one body: the title, the dots, the reason a code was refused,
/// and the keypad.
///
/// The same dots and keypad the parent set the code with, so entering it reads
/// as the same act. [state] supplies the digits and any refusal.
class ParentGateBody extends StatelessWidget {
  const ParentGateBody({required this.state, super.key});

  final ParentGateState state;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final ParentGateCubit cubit = context.read<ParentGateCubit>();
    final ParentGateState state = this.state;

    return AppFillScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppText(
                l10n.parentGateTitle,
                type: AppTextTypeEnum.heading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                l10n.parentGateBody,
                type: AppTextTypeEnum.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: AppPinDots(
                  filled: state.digits.length,
                  total: AuthRules.pinLength,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (state is ParentGateWrong)
                AppText(
                  failureCopy(l10n, state.failure),
                  type: AppTextTypeEnum.caption,
                  color: palette.errorInk,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xl),
            child: AppPinKeypad(
              onDigit: cubit.press,
              onBackspace: cubit.backspace,
            ),
          ),
        ],
      ),
    );
  }
}
