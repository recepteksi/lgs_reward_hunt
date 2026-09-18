import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_balance_pill_skeleton.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_child_pill_skeleton.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_snapshot_balance.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_snapshot_child_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/feedback/app_toast.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/feedback/app_toast_presenter.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_fill_scroll_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_empty_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_error_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_loading_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_shimmer.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton_list.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_caption.dart';

/// Section 11: the three states every page can be in, and the two notices.
///
/// Waiting, empty and failed are drawn at the height they get on a real page,
/// because all three are centred and a specimen squeezed into a strip proves
/// nothing about where the eye lands. The error copy is the app's own string,
/// not "something went wrong": the sentences are part of the component.
///
/// The toasts sit at the end because they are the only things here that are
/// never on screen for more than a moment — and the reward one is the loudest
/// surface in the app, which is worth seeing next to everything it is louder
/// than. The last button shows one the way the app does, through
/// `AppToastPresenter`.
class UiKitStatesSection extends StatelessWidget {
  const UiKitStatesSection({super.key});

  static const double _stateHeight = 220;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: _stateHeight, child: AppLoadingView()),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: _stateHeight,
          child: AppEmptyView(
            message: 'Bugün için görev yok.',
            caption: 'Ebeveynin görev eklemesini bekle.',
            actionLabel: 'Görev ekle',
            onAction: () {},
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: _stateHeight,
          child: AppErrorView(
            message: 'İnternet bağlantısı kurulamadı.',
            onRetry: () {},
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const UiKitCaption('Loading — skeletons under one shimmer'),
        const SizedBox(height: AppSpacing.sm),
        const Row(
          children: <Widget>[
            AppSnapshotChildPill(header: null),
            Spacer(),
            AppSnapshotBalance(balance: null),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        const Row(
          children: <Widget>[
            AppChildPillSkeleton(),
            Spacer(),
            AppBalancePillSkeleton(),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        const AppShimmer(
          child: Row(
            children: <Widget>[
              AppSkeleton.circle(size: AppSizes.iconTile),
              SizedBox(width: AppSpacing.md),
              Expanded(child: AppSkeleton.line()),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const SizedBox(height: _stateHeight * 2, child: AppSkeletonList()),
        const SizedBox(height: AppSpacing.md),
        const UiKitCaption('Fill, or scroll when short'),
        const SizedBox(height: AppSpacing.sm),
        const SizedBox(
          height: _stateHeight,
          child: AppFillScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AppText('Başlık', type: AppTextTypeEnum.heading),
                AppText('Tuş takımı', type: AppTextTypeEnum.body),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const UiKitCaption('Notices'),
        const SizedBox(height: AppSpacing.sm),
        const AppToast.reward(message: '+20 puan kazandın'),
        const SizedBox(height: AppSpacing.sm),
        const AppToast.info(message: 'Talebin annene gönderildi'),
        const SizedBox(height: AppSpacing.sm),
        Builder(
          builder: (BuildContext context) => AppButton.tonal(
            label: 'Show a toast',
            onPressed: () => AppToastPresenter.show(
              context,
              const AppToast.reward(message: '+20 puan kazandın'),
            ),
          ),
        ),
      ],
    );
  }
}
