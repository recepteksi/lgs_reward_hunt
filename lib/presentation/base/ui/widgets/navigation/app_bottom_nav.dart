import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/nav_tab_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_parent_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_item.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The bar at the foot of the app: four tabs and the parent's door.
///
/// Four, and the design says there will not be a fifth — the four are the whole
/// product, and a tab bar that grows is a product that has stopped deciding.
/// The parent button rides in the middle and above the bar rather than taking a
/// tab, because the parent's screens belong to a different person: put in the
/// row, they get tapped by accident and the app starts to feel supervised.
///
/// The selected tab is a tinted lozenge behind the icon, not an underline and
/// not a colour change alone: at ten pixels the label is too small to carry
/// selection on its own.
///
/// The parent button overflows the top of the bar, so whatever lays this out
/// must not clip it — inside a `Scaffold` that means passing it as
/// `bottomNavigationBar` with `extendBody`, not wrapping it in a clipping box.
///
/// [currentTab] is which of the four is showing, [onSelected] the tap, and
/// [onParentPressed] the way into the parent flow — which asks for a PIN
/// itself, because a button cannot hold a secret. The tabs are built by walking
/// [AppNavTabEnum] rather than by four hand-written entries, so the bar and the
/// enum cannot disagree about how many there are or what order they sit in.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.currentTab,
    required this.onSelected,
    required this.onParentPressed,
    super.key,
  });

  static const double _parentWidth = 66;

  static const double _parentLift = 30;

  static const double _shadowBlur = 30;

  static const double _shadowOffset = -10;

  static const int _parentSlot = ValueConstants.two;

  final AppNavTabEnum currentTab;

  final ValueChanged<AppNavTabEnum> onSelected;

  final VoidCallback onParentPressed;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);

    return Container(
      decoration: BoxDecoration(
        color: palette.navigationBar,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadii.xxxl),
        ),
        border: Border(
          top: BorderSide(color: palette.outline, width: AppSizes.border),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.softShadow,
            offset: const Offset(ValueConstants.zeroDouble, _shadowOffset),
            blurRadius: _shadowBlur,
          ),
        ],
      ),
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        right: AppSpacing.sm,
        top: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            for (final AppNavTabEnum tab in AppNavTabEnum.values) ...<Widget>[
              if (tab.index == _parentSlot)
                SizedBox(
                  width: _parentWidth,
                  child: Transform.translate(
                    offset: const Offset(
                      ValueConstants.zeroDouble,
                      -_parentLift,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AppParentButton(
                          semanticLabel: l10n.navParent,
                          onPressed: onParentPressed,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AppText(
                          l10n.navParent,
                          type: AppTextTypeEnum.label,
                          color: palette.primary,
                          style: const TextStyle(
                            letterSpacing: ValueConstants.zeroDouble,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              AppNavTabItem(
                icon: _iconFor(tab),
                label: navTabCopy(l10n, tab),
                isSelected: tab == currentTab,
                onTap: () => onSelected(tab),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _iconFor(AppNavTabEnum tab) => switch (tab) {
    AppNavTabEnum.home => AppIcons.home,
    AppNavTabEnum.rewards => AppIcons.rewards,
    AppNavTabEnum.progress => AppIcons.progress,
    AppNavTabEnum.profile => AppIcons.profile,
  };
}
