import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/rules/draft_rules.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_dashed_add_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_chip.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_day_cell.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_option_tile.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_pin_dots.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_pin_keypad.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_settings_row.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_stepper.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/input/app_toggle.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_header.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_step_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_template_editor.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_caption.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_panel.dart';

/// Section 09: the controls that take an answer — chips, days, rows, a counter —
/// and the header that says where in setup a form sits.
///
/// These are the only specimens on the sheet that keep state, and they keep it
/// here rather than being handed a fixed value, because selection is the whole
/// behaviour: a chip that cannot be tapped proves nothing about whether the
/// selected fill reads as selected on the yellow accent.
///
/// The settings rows are shown as one card with hairlines between them, which
/// is how the profile screen assembles them — separate cards would read as
/// unrelated settings rather than as a list.
class UiKitInputsSection extends StatefulWidget {
  const UiKitInputsSection({super.key});

  @override
  State<UiKitInputsSection> createState() => _UiKitInputsSectionState();
}

/// The demo's own selection, which belongs to nothing but this sheet.
class _UiKitInputsSectionState extends State<UiKitInputsSection> {
  static const List<String> _categories = <String>[
    'Tümü',
    'Ekran',
    'Lezzet',
    'Sosyal',
  ];

  static const List<String> _weekdays = <String>[
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
  ];

  String _category = _categories.first;

  static const int _selectedDay = 4;

  static const int _taskPoints = 20;

  int _day = _selectedDay;

  int _points = _taskPoints;

  bool _isEighth = true;

  static const int _pinTyped = 2;

  static const int _pinLength = 4;

  bool _isOn = true;

  TaskTemplateEntity _template = TaskTemplateEntity.draft(
    '${DraftRules.idPrefix}kit',
  ).withTopic('Çarpanlar ve katlar');

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        UiKitPanel(
          children: <Widget>[
            const UiKitCaption('Category chips'),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                for (final String category in _categories)
                  AppChip(
                    label: category,
                    isSelected: category == _category,
                    onTap: () => setState(() => _category = category),
                  ),
              ],
            ),
            const UiKitCaption('Day cells'),
            Row(
              children: <Widget>[
                for (
                  int index = ValueConstants.zero;
                  index < _weekdays.length;
                  index++
                ) ...<Widget>[
                  if (index > ValueConstants.zero)
                    const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppDayCell(
                      weekday: _weekdays[index],
                      day: index + ValueConstants.one,
                      isSelected: index + ValueConstants.one == _day,
                      onTap: () =>
                          setState(() => _day = index + ValueConstants.one),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppSettingsRow(
                icon: AppIcons.locked,
                title: 'Ebeveyn modu',
                subtitle: '4 haneli PIN ile',
                onTap: () {},
              ),
              Divider(height: AppSizes.border, color: palette.outline),
              AppSettingsRow(
                title: 'Görev puanı',
                subtitle: 'Sayaç · 5 puan adımlı',
                trailing: AppStepper(
                  value: _points,
                  decreaseLabel: 'Azalt',
                  increaseLabel: 'Artır',
                  onChanged: (int value) => setState(() => _points = value),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        UiKitPanel(
          children: <Widget>[
            const UiKitCaption('Option tiles · dashed add'),
            Row(
              children: <Widget>[
                Expanded(
                  child: AppOptionTile(
                    label: '7. sınıf',
                    isSelected: !_isEighth,
                    onTap: () => setState(() => _isEighth = false),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppOptionTile(
                    label: '8. sınıf',
                    isSelected: _isEighth,
                    onTap: () => setState(() => _isEighth = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppDashedAddButton(label: 'Görev ekle', onPressed: () {}),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        UiKitPanel(
          children: <Widget>[
            const UiKitCaption('PIN · toggle'),
            const Center(
              child: AppPinDots(filled: _pinTyped, total: _pinLength),
            ),
            const SizedBox(height: AppSpacing.md),
            AppPinKeypad(onDigit: (_) {}, onBackspace: () {}),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                const Expanded(child: UiKitCaption('Ödül açık')),
                AppToggle(
                  value: _isOn,
                  onChanged: (bool value) => setState(() => _isOn = value),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        UiKitPanel(
          children: <Widget>[
            const UiKitCaption('Task editor'),
            AppTaskTemplateEditor(
              template: _template,
              onChanged: (TaskTemplateEntity value) =>
                  setState(() => _template = value),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const UiKitPanel(
          children: <Widget>[
            UiKitCaption('Setup header · step 1 · step 4'),
            AppSetupHeader(step: AppSetupStepEnum.account),
            SizedBox(height: AppSpacing.md),
            AppSetupHeader(step: AppSetupStepEnum.child),
          ],
        ),
      ],
    );
  }
}
