import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/setup_step_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_step_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// Where a parent is in setup: the step's name, its number, and a bar.
///
/// Setup is six screens and a parent who cannot see the end of it abandons it
/// on the third. The bar is segments rather than a percentage because the steps
/// are discrete and unequal — "three of six" is a promise a fill of 50% does
/// not make.
///
/// [step] is which step this page is. The header reads its name, its number
/// and the total from it, so a page names where it sits in the flow and
/// nothing else.
class AppSetupHeader extends StatelessWidget {
  const AppSetupHeader({required this.step, super.key});

  static const double _barHeight = 4;

  final AppSetupStepEnum step;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final AppL10n l10n = AppL10n.of(context);
    final int total = AppSetupStepEnum.total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: AppText(
                setupStepCopy(l10n, step),
                type: AppTextTypeEnum.label,
              ),
            ),
            AppText(
              l10n.setupStepCount(step.number, total),
              type: AppTextTypeEnum.label,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: <Widget>[
            for (int index = ValueConstants.zero; index < total; index++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Container(
                    height: _barHeight,
                    decoration: BoxDecoration(
                      color: index < step.number
                          ? palette.primary
                          : palette.surfaceHigh,
                      borderRadius: BorderRadius.circular(AppRadii.round),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
