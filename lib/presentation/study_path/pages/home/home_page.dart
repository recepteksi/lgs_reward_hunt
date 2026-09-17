import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/study_path/cubit/home/home_cubit.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/study_path/read_models/study_map_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_app_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_balance_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_child_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_snapshot_balance.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_snapshot_child_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_icon_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_nav_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/navigation/app_tab_refresh.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_error_view.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/body/home_body.dart';
import 'package:lgs_reward_hunt/presentation/study_path/pages/home/widgets/home_map_skeleton.dart';

/// The home page: the child's road to the exam.
///
/// Full-bleed — the map runs under a floating app bar carrying whose map it is
/// and their balance, and under the navigation bar — with the day sheet over
/// its bottom. Until the map has loaded the page is a plain waiting or failed
/// page, with no bars to tap.
///
/// The app bar also carries, in a debug build only, the door to the UI kit
/// sheet. `kDebugMode` is a compile-time constant, so the button and
/// everything it reaches are gone from a release binary.
///
/// The `switch` over [HomeState] is exhaustive; the three states that carry a
/// map show the same body, so ticking a task never blanks the road.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String _uiKitLabel = 'UI Kit';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>()..load(),
      child: AppTabRefresh(
        tab: AppNavTabEnum.home,
        onShown: (BuildContext context) =>
            context.read<HomeCubit>().load(quietly: true),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (BuildContext context, HomeState state) => switch (state) {
            HomeLoading(:final snapshot) => AppScaffold(
              extendBehindAppBar: true,
              appBar: AppAppBar.overlay(
                start: AppSnapshotChildPill(header: snapshot.header),
                actions: <Widget>[
                  AppSnapshotBalance(balance: snapshot.balance),
                ],
              ),
              body: const HomeMapSkeleton(),
            ),
            HomeFailed(:final failure) => AppScaffold(
              body: AppErrorView(
                message: failureCopy(AppL10n.of(context), failure),
                onRetry: context.read<HomeCubit>().load,
              ),
            ),
            HomeReady(:final map) => _frame(context, map),
            HomeCompleting(:final map, :final taskId) => _frame(
              context,
              map,
              busyTaskId: taskId,
            ),
            HomeCompleteFailed(:final map, :final failure) => _frame(
              context,
              map,
              failure: failure,
            ),
          },
        ),
      ),
    );
  }

  AppScaffold _frame(
    BuildContext context,
    StudyMapReadModel map, {
    String? busyTaskId,
    Failure? failure,
  }) {
    return AppScaffold(
      extendBehindAppBar: true,
      appBar: AppAppBar.overlay(
        start: AppChildPill(
          name: map.child.name,
          avatar: map.avatar,
          subtitle: AppL10n.of(context).mapLeg(
            map.path.zoneOf(map.path.todayIndex),
            DateFormat.MMMM(Localizations.localeOf(context).toLanguageTag())
                .format(map.path.today),
          ),
        ),
        actions: <Widget>[
          if (kDebugMode)
            AppIconButton.plain(
              icon: AppIcons.categoryScreen,
              semanticLabel: _uiKitLabel,
              onPressed: () => context.push(AppRoutePaths.uiKit.path()),
            ),
          AppBalancePill(balance: map.balance),
        ],
      ),
      body: HomeBody(
        map: map,
        onComplete: context.read<HomeCubit>().complete,
        busyTaskId: busyTaskId,
        failure: failure,
      ),
    );
  }
}
