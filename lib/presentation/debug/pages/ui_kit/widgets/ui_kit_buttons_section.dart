import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_icon_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_parent_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_caption.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_panel.dart';

/// Section 03: every button, in every state it has.
///
/// Press one. The whole reason this section is in the app rather than in the
/// design tool is that the primary button's four pixel travel and the edge it
/// lands on are motion — a still frame shows a shadow and says nothing about
/// how the control feels under a thumb.
///
/// The disabled specimen is here for the same reason it exists at all: a
/// control that keeps its colour when it stops working is a control a child
/// keeps tapping.
class UiKitButtonsSection extends StatelessWidget {
  const UiKitButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        UiKitPanel(
          children: <Widget>[
            const UiKitCaption('Filled · primary action'),
            AppButton.filled(
              label: 'Görevi tamamla',
              onPressed: () {},
              isExpanded: true,
            ),
            const AppButton.filled(
              label: 'Devre dışı',
              onPressed: null,
              isExpanded: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        UiKitPanel(
          children: <Widget>[
            const UiKitCaption('Reward · spending points'),
            AppButton.reward(
              label: 'Ödülü iste',
              icon: AppIcons.star,
              onPressed: () {},
              isExpanded: true,
            ),
            AppButton.rewardTonal(
              label: 'Tonal ödül',
              onPressed: () {},
              isExpanded: true,
            ),
            const AppText(
              'Never white on the reward colour; always the dark ink.',
              type: AppTextTypeEnum.meta,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        UiKitPanel(
          children: <Widget>[
            const UiKitCaption('Tonal · outlined · text'),
            AppButton.tonal(
              label: 'Görev ekle',
              onPressed: () {},
              isExpanded: true,
            ),
            AppButton.outlined(
              label: 'Reddet',
              onPressed: () {},
              isExpanded: true,
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: AppButton.text(label: 'Talebi geri al', onPressed: () {}),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        UiKitPanel(
          children: <Widget>[
            const UiKitCaption('Icon buttons · 44 px'),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                AppIconButton.tonal(
                  icon: AppIcons.plus,
                  semanticLabel: 'Ekle',
                  onPressed: () {},
                ),
                AppIconButton(
                  icon: AppIcons.forward,
                  semanticLabel: 'İleri',
                  onPressed: () {},
                ),
                AppIconButton(
                  icon: AppIcons.retry,
                  semanticLabel: 'Yenile',
                  onPressed: () {},
                ),
                AppIconButton.plain(
                  icon: AppIcons.back,
                  semanticLabel: 'Geri',
                  onPressed: () {},
                ),
                AppIconButton.plain(
                  icon: AppIcons.close,
                  semanticLabel: 'Kaldır',
                  onPressed: () {},
                ),
                AppParentButton(semanticLabel: 'Ebeveyn', onPressed: () {}),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
