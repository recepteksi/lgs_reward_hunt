import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// What a page shows while it is still asking.
///
/// A ring and a word, and nothing else — no skeleton of the layout to come. A
/// placeholder that guesses at the shape of the answer is wrong for every
/// answer that is not the expected one, and the wait here is a request rather
/// than a computation.
///
/// It exists as a widget so that waiting looks identical on every page, and so
/// that the day it becomes something with more character it becomes one
/// everywhere.
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  static const double _size = 34;

  static const double _stroke = 4;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox.square(
            dimension: _size,
            child: CircularProgressIndicator(
              strokeWidth: _stroke,
              strokeCap: StrokeCap.round,
              color: palette.primary,
              backgroundColor: palette.surfaceHigh,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppText(
            AppL10n.of(context).commonLoading,
            type: AppTextTypeEnum.meta,
          ),
        ],
      ),
    );
  }
}
