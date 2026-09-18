import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/intro/intro_slide_enum.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/intro/widgets/intro_emblem_art.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/intro/widgets/intro_rewards_art.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/intro/widgets/intro_tasks_art.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One slide: a picture centred in the space it is given, then its words.
///
/// The picture takes whatever height is left and the title and sentence sit at
/// the foot, so the words land in the same place on every slide and on every
/// phone — only the picture grows or shrinks. On a short screen the picture is
/// scaled down to fit rather than scrolled, because a tour that scrolls is a
/// tour nobody reads. [slide] chooses both, through one exhaustive `switch`.
class IntroSlide extends StatelessWidget {
  const IntroSlide({required this.slide, super.key});

  final IntroSlideEnum slide;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);

    final (Widget art, String title, String body) = switch (slide) {
      IntroSlideEnum.emblem => (
        const IntroEmblemArt(),
        l10n.introTitleOne,
        l10n.introBodyOne,
      ),
      IntroSlideEnum.tasks => (
        const IntroTasksArt(),
        l10n.introTitleTwo,
        l10n.introBodyTwo,
      ),
      IntroSlideEnum.rewards => (
        const IntroRewardsArt(),
        l10n.introTitleThree,
        l10n.introBodyThree,
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) => Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Center(child: art),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppText(title, type: AppTextTypeEnum.heading),
        const SizedBox(height: AppSpacing.md),
        AppText(body, type: AppTextTypeEnum.body),
      ],
    );
  }
}
