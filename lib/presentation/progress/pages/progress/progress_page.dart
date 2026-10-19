import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/progress/cubit/progress/progress_cubit.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_app_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_balance_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_child_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_snapshot_balance.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_snapshot_child_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_tab_refresh.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_error_view.dart';
import 'package:lgs_reward_hunt/presentation/progress/pages/progress/body/progress_body.dart';
import 'package:lgs_reward_hunt/presentation/progress/pages/progress/widgets/progress_skeleton.dart';

/// The progress tab: level, streak, the week, the month, and badges.
///
/// It carries the same floating bar and navigation as the other tabs. Nothing
/// on it can be changed, so it is a read and a render; the `switch` over
/// [ProgressState] is exhaustive.
class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProgressCubit>(
      create: (_) => getIt<ProgressCubit>()..load(),
      child: AppTabRefresh(
        tab: AppNavTabEnum.progress,
        onShown: (BuildContext context) =>
            context.read<ProgressCubit>().load(quietly: true),
        child: BlocBuilder<ProgressCubit, ProgressState>(
          builder: (BuildContext context, ProgressState state) =>
              switch (state) {
                ProgressLoading(:final snapshot) => AppScaffold(
                  appBar: AppAppBar.overlay(
                    start: AppSnapshotChildPill(header: snapshot.header),
                    actions: <Widget>[
                      AppSnapshotBalance(balance: snapshot.balance),
                    ],
                  ),
                  body: const ProgressSkeleton(),
                ),
                ProgressFailed(:final failure) => AppScaffold(
                  body: AppErrorView(
                    message: failureCopy(AppL10n.of(context), failure),
                    onRetry: context.read<ProgressCubit>().load,
                  ),
                ),
                ProgressReady(:final header, :final progress) => AppScaffold(
                  appBar: AppAppBar.overlay(
                    start: AppChildPill(
                      name: header.child.name,
                      avatar: header.avatar,
                      subtitle: AppL10n.of(context)
                          .childGrade(header.child.gradeLevel),
                    ),
                    actions: <Widget>[
                      AppBalancePill(balance: progress.account.balance),
                    ],
                  ),
                  body: ProgressBody(progress: progress),
                ),
              },
        ),
      ),
    );
  }
}
