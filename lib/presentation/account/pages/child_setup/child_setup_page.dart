import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/account/cubit/child_setup/child_setup_cubit.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_setup/body/child_setup_body.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_error_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton_list.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';

/// The household's children, and the way to add one.
///
/// The screen owns where the two buttons lead. Adding pushes the child form on
/// top and reloads the list when it comes back, whether or not a child was
/// saved — the list is the server's, and asking again is cheaper than keeping
/// a copy in step. Continuing moves on to the task setup step.
///
/// The `switch` over [ChildSetupState] is exhaustive, so a state added later
/// cannot render as a blank screen.
class ChildSetupPage extends StatelessWidget {
  const ChildSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChildSetupCubit>(
      create: (_) => getIt<ChildSetupCubit>()..load(),
      child: AppScaffold(
        padding: const EdgeInsets.all(AppSpacing.xl),
        body: BlocBuilder<ChildSetupCubit, ChildSetupState>(
          builder: (BuildContext context, ChildSetupState state) =>
              switch (state) {
                ChildSetupLoading() => const AppSkeletonList(),
                ChildSetupFailed(:final failure) => AppErrorView(
                  message: failureCopy(AppL10n.of(context), failure),
                  onRetry: context.read<ChildSetupCubit>().load,
                ),
                ChildSetupLoaded(:final household) => ChildSetupBody(
                  household: household,
                  onAdd: () => _add(context),
                  onRemove: context.read<ChildSetupCubit>().remove,
                  onContinue: () => context.go(AppRoutePaths.taskSetup.path()),
                ),
              },
        ),
      ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final ChildSetupCubit cubit = context.read<ChildSetupCubit>();
    await context.push(AppRoutePaths.childForm.path());
    await cubit.load();
  }
}
