import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/duration_constants.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/intro/intro_slide_enum.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/intro/items/intro_slide.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/intro/widgets/intro_top_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';

/// The intro's one body: the indicator, the slides, and the button under them.
///
/// The button sits outside the `PageView` rather than on each slide, so a swipe
/// moves the picture and the words while the thumb's target stays put. On the
/// last slide it stops saying "Devam" and says what happens next — making the
/// account — and calls [onFinish], which is also what the skip calls.
class IntroBody extends StatefulWidget {
  const IntroBody({required this.onFinish, super.key});

  final VoidCallback onFinish;

  @override
  State<IntroBody> createState() => _IntroBodyState();
}

/// Holds the page controller and the slide showing.
class _IntroBodyState extends State<IntroBody> {
  final PageController _pages = PageController();

  int _index = ValueConstants.zero;

  bool get _isLast =>
      _index == IntroSlideEnum.values.length - ValueConstants.one;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);

    return Column(
      children: <Widget>[
        IntroTopBar(
          current: _index,
          total: IntroSlideEnum.values.length,
          onSkip: widget.onFinish,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Expanded(
          child: PageView.builder(
            controller: _pages,
            itemCount: IntroSlideEnum.values.length,
            onPageChanged: (int index) => setState(() => _index = index),
            itemBuilder: (_, int index) =>
                IntroSlide(slide: IntroSlideEnum.values[index]),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton.filled(
          label: _isLast ? l10n.introCreateAccount : l10n.introContinue,
          isExpanded: true,
          onPressed: _next,
        ),
      ],
    );
  }

  void _next() {
    if (_isLast) {
      widget.onFinish();
      return;
    }

    _pages.nextPage(
      duration: DurationConstants.pageTurn,
      curve: Curves.easeOut,
    );
  }
}
