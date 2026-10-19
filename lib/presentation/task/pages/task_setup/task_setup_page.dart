import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/task/cubit/task_setup/task_setup_cubit.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_error_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_loading_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton_list.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:lgs_reward_hunt/presentation/task/pages/task_setup/body/task_setup_body.dart';

/// The task setup step: the plan a child's days are written from.
///
/// It opens on the parent's saved plan or the suggested standard day, lets the
/// parent edit it line by line, and saving writes a fortnight of tasks for
/// every child in the household. Saved, it moves on to the reward setup step. There is no back arrow, as in the design: the steps
/// before this one are finished.
///
/// The `switch` over [TaskSetupState] is exhaustive; every state that carries
/// a plan shows the same body, so the list does not blink while it saves.
class TaskSetupPage extends StatelessWidget {
  const TaskSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskSetupCubit>(
      create: (_) => getIt<TaskSetupCubit>()..load(),
      child: BlocListener<TaskSetupCubit, TaskSetupState>(
        listener: (BuildContext context, TaskSetupState state) {
          if (state is TaskSetupSaved) {
            context.go(AppRoutePaths.rewardSetup.path());
          }
        },
        child: AppScaffold(
          padding: const EdgeInsets.all(AppSpacing.xl),
          body: BlocBuilder<TaskSetupCubit, TaskSetupState>(
            builder: (BuildContext context, TaskSetupState state) =>
                switch (state) {
                  TaskSetupLoading() => const AppSkeletonList(),
                  TaskSetupSaved() => const AppLoadingView(),
                  TaskSetupLoadFailed(:final failure) => AppErrorView(
                    message: failureCopy(AppL10n.of(context), failure),
                    onRetry: context.read<TaskSetupCubit>().load,
                  ),
                  TaskSetupEditing(:final plan) => TaskSetupBody(plan: plan),
                  TaskSetupSaving(:final plan) => TaskSetupBody(
                    plan: plan,
                    isSaving: true,
                  ),
                  TaskSetupSaveFailed(:final plan, :final failure) =>
                    TaskSetupBody(plan: plan, failure: failure),
                },
          ),
        ),
      ),
    );
  }
}
