import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/reward/cubit/rewards/rewards_cubit.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_app_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_balance_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_child_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_snapshot_balance.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_snapshot_child_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/feedback/app_toast.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/feedback/app_toast_presenter.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_tab_refresh.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_error_view.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/rewards/body/rewards_body.dart';
import 'package:lgs_reward_hunt/presentation/reward/pages/rewards/widgets/rewards_skeleton.dart';

/// The rewards tab: the balance, the shop, and the child's requests.
///
/// It carries the same floating bar as the map — whose tab and the balance —
/// and the navigation bar. A request that went through is announced once, as
/// a toast, by the listener; a refused one is shown in the body where the
/// child tapped.
///
/// The `switch` over [RewardsState] is exhaustive; every state with a shop
/// shows the same body, so asking for a reward never blanks the grid.
class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RewardsCubit>(
      create: (_) => getIt<RewardsCubit>()..load(),
      child: AppTabRefresh(
        tab: AppNavTabEnum.rewards,
        onShown: (BuildContext context) =>
            context.read<RewardsCubit>().load(quietly: true),
        child: BlocConsumer<RewardsCubit, RewardsState>(
          listenWhen: (_, RewardsState state) => state is RewardsRequested,
          listener: (BuildContext context, RewardsState state) {
            if (state is! RewardsRequested) return;
            AppToastPresenter.show(
              context,
              AppToast.info(
                message: AppL10n.of(context)
                    .rewardsRequestSent(state.rewardName),
              ),
            );
          },
          builder: (BuildContext context, RewardsState state) =>
              switch (state) {
                RewardsLoading(:final snapshot) => AppScaffold(
                  appBar: AppAppBar.overlay(
                    start: AppSnapshotChildPill(header: snapshot.header),
                    actions: <Widget>[
                      AppSnapshotBalance(balance: snapshot.balance),
                    ],
                  ),
                  body: const RewardsSkeleton(),
                ),
                RewardsFailed(:final failure) => AppScaffold(
                  body: AppErrorView(
                    message: failureCopy(AppL10n.of(context), failure),
                    onRetry: context.read<RewardsCubit>().load,
                  ),
                ),
                RewardsShowing() => AppScaffold(
                  appBar: AppAppBar.overlay(
                    start: AppChildPill(
                      name: state.header.child.name,
                      avatar: state.header.avatar,
                      subtitle: AppL10n.of(context)
                          .childGrade(state.header.child.gradeLevel),
                    ),
                    actions: <Widget>[
                      AppBalancePill(balance: state.shop.balance),
                    ],
                  ),
                  body: RewardsBody(
                    shop: state.shop,
                    onRequest: context.read<RewardsCubit>().request,
                    busyRewardId: state is RewardsRequesting
                        ? state.rewardId
                        : null,
                    failure: state is RewardsRequestFailed
                        ? state.failure
                        : null,
                  ),
                ),
              },
        ),
      ),
    );
  }
}
