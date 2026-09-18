import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/parent/cubit/parent/parent_cubit.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/parent_notice_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_app_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/feedback/app_toast.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/feedback/app_toast_presenter.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_error_view.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/body/parent_body.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/widgets/parent_skeleton.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';

/// The parent's side: approvals, the week's tasks, the reward pool, and which
/// child the device is on.
///
/// It is reached through the PIN gate and has no navigation bar — it belongs
/// to a different person than the tabs do. The bar carries the parent's name
/// and the way out, which returns to the child's profile, where the door was.
/// An action worth confirming is announced once, as a toast.
/// The `switch` over [ParentState] is exhaustive; every state with a
/// dashboard shows the same body, so an action never blanks the page.
class ParentPage extends StatelessWidget {
  const ParentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ParentCubit>(
      create: (_) => getIt<ParentCubit>()..load(),
      child: BlocConsumer<ParentCubit, ParentState>(
        listenWhen: (_, ParentState state) => state is ParentDone,
        listener: (BuildContext context, ParentState state) {
          if (state is! ParentDone) return;
          AppToastPresenter.show(
            context,
            AppToast.info(
              message: parentNoticeCopy(AppL10n.of(context), state.notice),
            ),
          );
        },
        builder: (BuildContext context, ParentState state) {
          final AppL10n l10n = AppL10n.of(context);
          final AppAppBar bar = AppAppBar(
            title: state is ParentShowing
                ? state.dashboard.household.parent.name
                : null,
            actions: <Widget>[
              AppButton.text(
                label: l10n.parentExit,
                onPressed: () => context.go(AppRoutePaths.profile.path()),
              ),
            ],
          );

          return AppScaffold(
            background: AppPalette.of(context).surfaceHigh,
            appBar: bar,
            body: switch (state) {
              ParentLoading() => const ParentSkeleton(),
              ParentFailed(:final failure) => AppErrorView(
                message: failureCopy(l10n, failure),
                onRetry: context.read<ParentCubit>().load,
              ),
              ParentShowing(:final dashboard) => ParentBody(
                dashboard: dashboard,
                isBusy: state is ParentWorking,
                failure: state is ParentActionFailed ? state.failure : null,
              ),
            },
          );
        },
      ),
    );
  }
}
