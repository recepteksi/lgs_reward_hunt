import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// What a page shows when it could not get an answer.
///
/// One sentence and one action. Every failure in this app ends in "try again",
/// so the button's words belong here rather than at each call site — a screen
/// that offers two ways out of a network error is a screen where neither is
/// obviously the one to press.
///
/// The whole card is the error container rather than a plain surface with red
/// text, because a failure is a state of the page and not an annotation on it.
/// It is the softest red in the palette: the student did nothing wrong.
///
/// [message] arrives already localized — turning a `Failure` into words is
/// `failureCopy`'s job, and a view that did it itself would be a second place
/// deciding what a failure says. [onRetry] is what the button asks the Cubit to
/// do again.
class AppErrorView extends StatelessWidget {
  const AppErrorView({required this.message, required this.onRetry, super.key});

  static const double _tile = 44;

  final String message;

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: palette.errorContainer,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          border: Border.all(color: palette.error, width: AppSizes.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: _tile,
              height: _tile,
              decoration: BoxDecoration(
                color: palette.surface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AppIcon(
                  AppIcons.alert,
                  color: palette.errorInk,
                  size: AppSizes.iconSizeLarge,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppText(
              message,
              type: AppTextTypeEnum.body,
              textAlign: TextAlign.center,
              weight: FontWeight.w900,
              color: palette.errorInk,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.errorOutlined(
              label: AppL10n.of(context).commonRetry,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
