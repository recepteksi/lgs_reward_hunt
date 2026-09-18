import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_accent_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_appearance_picker.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/items/ui_kit_section.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_avatars_section.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_badges_section.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_buttons_section.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_colors_section.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_inputs_section.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_map_section.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_navigation_section.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_progress_section.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_rewards_section.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_states_section.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_tasks_section.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_typography_section.dart';

/// The kit's one body: the appearance controls, then the twelve sections.
///
/// It takes the current preview choices and the callbacks for changing them
/// rather than owning them, because the screen above it is what re-themes the
/// tree — a body that held the accent would be deciding what the scaffold looks
/// like from inside it.
///
/// The sections are `items/` rather than more bodies. A scaffold has one body;
/// what fills it is a list of parts, and each part here is one group of
/// specimens.
///
/// The sheet's own words — section names, hints, the labels over a group — are
/// English like the rest of the code. The sample strings inside the specimens
/// stay Turkish, because they stand in for the copy that ships, and a type
/// scale proved on English words has not met the dotless `ı` or the compounds
/// that decide whether a task title wraps.
///
/// [mode] and [accent] are what is being previewed, [onModeChanged] and
/// [onAccentChanged] the taps that change it.
class UiKitBody extends StatelessWidget {
  const UiKitBody({
    required this.mode,
    required this.accent,
    required this.onModeChanged,
    required this.onAccentChanged,
    super.key,
  });

  final ThemeMode mode;

  final AppAccentEnum accent;

  final ValueChanged<ThemeMode> onModeChanged;

  final ValueChanged<AppAccentEnum> onAccentChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxxl,
      ),
      children: <Widget>[
        AppAppearancePicker(
          mode: mode,
          accent: accent,
          onModeChanged: onModeChanged,
          onAccentChanged: onAccentChanged,
        ),
        const SizedBox(height: AppSpacing.xl),
        for (
          int index = ValueConstants.zero;
          index < _sections.length;
          index++
        ) ...<Widget>[
          UiKitSection(
            index: index + ValueConstants.one,
            title: _sections[index].title,
            hint: _sections[index].hint,
            child: _sections[index].child,
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ],
    );
  }

  static const List<({String title, String hint, Widget child})> _sections =
      <({String title, String hint, Widget child})>[
        (
          title: 'Colour tokens',
          hint: 'Derived from three seeds · all of them move with the accent',
          child: UiKitColorsSection(),
        ),
        (
          title: 'Typography',
          hint: 'Nunito · 700 / 800 / 900',
          child: UiKitTypographySection(),
        ),
        (
          title: 'Buttons',
          hint: '48 px · radius 16 · solid bottom edge',
          child: UiKitButtonsSection(),
        ),
        (
          title: 'Badges',
          hint: 'Pill · radius 999',
          child: UiKitBadgesSection(),
        ),
        (
          title: 'Task row',
          hint: 'Pending · done · locked',
          child: UiKitTasksSection(),
        ),
        (
          title: 'Reward card',
          hint: 'Shop grid · four states',
          child: UiKitRewardsSection(),
        ),
        (
          title: 'Map stops',
          hint: 'Size is the hierarchy · today is the largest',
          child: UiKitMapSection(),
        ),
        (
          title: 'Progress',
          hint: 'Ring · level · week',
          child: UiKitProgressSection(),
        ),
        (
          title: 'Selectors and inputs',
          hint: 'Chip · day cell · settings row · stepper',
          child: UiKitInputsSection(),
        ),
        (
          title: 'Bars',
          hint: 'App bar · four tabs + the parent button',
          child: UiKitNavigationSection(),
        ),
        (
          title: 'States and notices',
          hint: 'Loading · empty · error · toast',
          child: UiKitStatesSection(),
        ),
        (
          title: 'Avatar',
          hint: 'Drawn from the catalogue recipe · eight styles',
          child: UiKitAvatarsSection(),
        ),
      ];
}
