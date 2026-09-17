import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/reward/cubit/reward_setup/reward_setup_cubit.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/feedback/app_toast.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/feedback/app_toast_presenter.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_error_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_loading_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton_list.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/reward_setup/body/reward_setup_body.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';

/// The last setup step: the rewards the points will be spent on.
///
/// It opens on the parent's active rewards or the suggested starting pool,
/// lets the parent edit it reward by reward, and saving moves on to the last
/// question — which child this device opens on, with the design's closing
/// toast counting what was set up. There is no back arrow, as in the design.
///
/// The `switch` over [RewardSetupState] is exhaustive; every state that carries
/// a pool shows the same body, so the list does not blink while it saves.
class RewardSetupPage extends StatelessWidget {
  const RewardSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RewardSetupCubit>(
      create: (_) => getIt<RewardSetupCubit>()..load(),
      child: BlocListener<RewardSetupCubit, RewardSetupState>(
        listener: (BuildContext context, RewardSetupState state) {
          if (state is! RewardSetupSaved) return;
          final AppL10n l10n = AppL10n.of(context);
          final int rewards = state.pool.rewards.length;
          AppToastPresenter.show(
            context,
            AppToast.info(
              message: switch (state.taskCount) {
                final int tasks => l10n.setupDoneToast(tasks, rewards),
                null => l10n.setupDoneRewardsToast(rewards),
              },
            ),
          );
          context.go(AppRoutePaths.deviceChild.path());
        },
        child: AppScaffold(
          padding: const EdgeInsets.all(AppSpacing.xl),
          body: BlocBuilder<RewardSetupCubit, RewardSetupState>(
            builder: (BuildContext context, RewardSetupState state) =>
                switch (state) {
                  RewardSetupLoading() => const AppSkeletonList(),
                  RewardSetupSaved() => const AppLoadingView(),
                  RewardSetupLoadFailed(:final failure) => AppErrorView(
                    message: failureCopy(AppL10n.of(context), failure),
                    onRetry: context.read<RewardSetupCubit>().load,
                  ),
                  RewardSetupEditing(:final pool) => RewardSetupBody(
                    pool: pool,
                  ),
                  RewardSetupSaving(:final pool) => RewardSetupBody(
                    pool: pool,
                    isSaving: true,
                  ),
                  RewardSetupSaveFailed(:final pool, :final failure) =>
                    RewardSetupBody(pool: pool, failure: failure),
                },
          ),
        ),
      ),
    );
  }
}
