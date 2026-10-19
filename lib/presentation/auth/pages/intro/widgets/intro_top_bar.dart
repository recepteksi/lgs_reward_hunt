import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/duration_constants.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';

/// Where the parent is in the intro, and the way out of it.
///
/// The segments fill up to and including [current] rather than marking only
/// the slide showing, so the bar reads as progress through a short tour, the
/// same way the setup header does on the steps after it. [total] is the number
/// of slides and [onSkip] leaves the intro from any of them.
class IntroTopBar extends StatelessWidget {
  const IntroTopBar({
    required this.current,
    required this.total,
    required this.onSkip,
    super.key,
  });

  final int current;

  final int total;

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              for (int index = ValueConstants.zero; index < total; index++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: AnimatedContainer(
                      duration: DurationConstants.pageTurn,
                      height: AppSizes.progressBar,
                      decoration: BoxDecoration(
                        color: index <= current
                            ? palette.primary
                            : palette.outline,
                        borderRadius: BorderRadius.circular(AppRadii.round),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        AppButton.text(label: AppL10n.of(context).introSkip, onPressed: onSkip),
      ],
    );
  }
}
