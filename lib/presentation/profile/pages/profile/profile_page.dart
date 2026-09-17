import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/profile/cubit/profile/profile_cubit.dart';
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
import 'package:lgs_reward_hunt/presentation/profile/pages/profile/body/profile_body.dart';
import 'package:lgs_reward_hunt/presentation/profile/pages/profile/widgets/profile_skeleton.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';

/// The profile tab: who the child is, the appearance setting, and the door to
/// the parent's side.
///
/// It carries the same floating bar and navigation as the other tabs. The
/// `switch` over [ProfileState] is exhaustive.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (_) => getIt<ProfileCubit>()..load(),
      child: AppTabRefresh(
        tab: AppNavTabEnum.profile,
        onShown: (BuildContext context) =>
            context.read<ProfileCubit>().load(quietly: true),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (BuildContext context, ProfileState state) =>
              switch (state) {
                ProfileLoading(:final snapshot) => AppScaffold(
                  appBar: AppAppBar.overlay(
                    start: AppSnapshotChildPill(header: snapshot.header),
                    actions: <Widget>[
                      AppSnapshotBalance(balance: snapshot.balance),
                    ],
                  ),
                  body: ProfileSkeleton(
                    header: snapshot.header,
                    onParentMode: () =>
                        context.push(AppRoutePaths.parentGate.path()),
                  ),
                ),
                ProfileFailed(:final failure) => AppScaffold(
                  body: AppErrorView(
                    message: failureCopy(AppL10n.of(context), failure),
                    onRetry: context.read<ProfileCubit>().load,
                  ),
                ),
                ProfileReady(:final profile) => AppScaffold(
                  appBar: AppAppBar.overlay(
                    start: AppChildPill(
                      name: profile.header.child.name,
                      avatar: profile.header.avatar,
                      subtitle: AppL10n.of(context)
                          .childGrade(profile.header.child.gradeLevel),
                    ),
                    actions: <Widget>[
                      AppBalancePill(balance: profile.progress.account.balance),
                    ],
                  ),
                  body: ProfileBody(
                    profile: profile,
                    onParentMode: () =>
                        context.push(AppRoutePaths.parentGate.path()),
                  ),
                ),
              },
        ),
      ),
    );
  }
}
