import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/parent_pin/parent_pin_cubit.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/rules/auth_rules.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_pin_dots.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_pin_keypad.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_fill_scroll_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_header.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_step_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The PIN screen's one body, in either of its two passes.
///
/// [isRepeat] changes the title and the sentence under it and nothing else. The
/// dots and the keypad are the same objects in the same places, because they
/// are the same act — a screen that rearranged itself between the two passes
/// would suggest the second one was asking for something new.
///
/// [failure] appears above the keypad, where the eye already is.
class ParentPinBody extends StatelessWidget {
  const ParentPinBody({
    required this.digits,
    required this.isRepeat,
    this.failure,
    super.key,
  });

  final String digits;

  final bool isRepeat;

  final Failure? failure;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final ParentPinCubit cubit = context.read<ParentPinCubit>();
    final Failure? failure = this.failure;

    return AppFillScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const AppSetupHeader(step: AppSetupStepEnum.parentPin),
              const SizedBox(height: AppSpacing.xl),
              AppText(
                isRepeat ? l10n.pinTitleRepeat : l10n.pinTitleSet,
                type: AppTextTypeEnum.heading,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                isRepeat ? l10n.pinBodyRepeat : l10n.pinBodySet,
                type: AppTextTypeEnum.body,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: AppPinDots(
                  filled: digits.length,
                  total: AuthRules.pinLength,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (failure != null)
                Center(
                  child: AppText(
                    failureCopy(l10n, failure),
                    type: AppTextTypeEnum.caption,
                    color: palette.errorInk,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          Column(
            children: <Widget>[
              const SizedBox(height: AppSpacing.xl),
              AppPinKeypad(onDigit: cubit.press, onBackspace: cubit.backspace),
              const SizedBox(height: AppSpacing.lg),
              AppText(
                l10n.pinNote,
                type: AppTextTypeEnum.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
