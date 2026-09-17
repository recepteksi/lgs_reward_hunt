import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_app_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_balance_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_child_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_icon_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_bottom_nav.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_tab_refresh.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_tab_scope.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// Section 10: the two bars a page frames itself with — the app bar at the top
/// and the navigation bar at the foot, tappable.
///
/// The floating pills a tab's overlay bar carries — whose tab, and the
/// balance — are shown on the map's ground. The app bar is shown twice: a setup page's, which is only a way back, and
/// a titled one with an action, which is what a tab's page wears.
///
/// It is shown on the map's ground and with room above it, because the parent
/// button overlaps the top of the bar by thirty pixels — the specimen is as
/// much about that overlap as about the tabs, and a frame that clipped it would
/// be showing a different component from the one that ships.
///
/// Tapping moves the selection so the tinted lozenge can be checked in every
/// accent: at ten pixels the label cannot carry selection alone, and whether
/// the lozenge is visible enough is a question only a real screen answers.
class UiKitNavigationSection extends StatefulWidget {
  const UiKitNavigationSection({super.key});

  @override
  State<UiKitNavigationSection> createState() => _UiKitNavigationSectionState();
}

/// Which tab the specimen is showing.
class _UiKitNavigationSectionState extends State<UiKitNavigationSection> {
  static const int _balance = 480;

  AppNavTabEnum _tab = AppNavTabEnum.home;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.xxl),
          child: Column(
            children: <Widget>[
              AppAppBar(onBack: () {}),
              AppAppBar(
                title: 'Ödüller',
                onBack: () {},
                actions: <Widget>[
                  AppIconButton.plain(
                    icon: AppIcons.plus,
                    semanticLabel: 'Ekle',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTabScope(
          currentTab: AppNavTabEnum.rewards,
          child: AppTabRefresh(
            tab: AppNavTabEnum.rewards,
            onShown: (_) {},
            child: const AppText(
              'A kept-alive tab refreshes when it comes back on screen.',
              type: AppTextTypeEnum.meta,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: palette.mapBase,
            borderRadius: BorderRadius.circular(AppRadii.xxl),
          ),
          child: const Row(
            children: <Widget>[
              Flexible(
                child: AppChildPill(
                  name: 'Elif',
                  avatar: null,
                  subtitle: '1. etap · Eylül',
                ),
              ),
              Spacer(),
              AppBalancePill(balance: _balance),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.only(top: AppSpacing.xxl),
          decoration: BoxDecoration(
            color: palette.mapBase,
            borderRadius: BorderRadius.circular(AppRadii.xxl),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(AppRadii.xxl),
            ),
            child: AppBottomNav(
              currentTab: _tab,
              onSelected: (AppNavTabEnum tab) => setState(() => _tab = tab),
              onParentPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
