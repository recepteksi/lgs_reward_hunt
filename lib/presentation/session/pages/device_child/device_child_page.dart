import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/session/cubit/device_child/device_child_cubit.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_app_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_error_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_loading_view.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_skeleton_list.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:lgs_reward_hunt/presentation/session/pages/device_child/body/device_child_body.dart';

/// Which child this device opens on — the end of setup.
///
/// Setup always passes through here, and with one child the Cubit chooses
/// before anything is shown, so a parent of one never sees the question. With
/// two, picking a child stores it and opens the map. The back arrow returns to
/// the child setup step, as the design's does, because that is where the
/// household is changed.
class DeviceChildPage extends StatelessWidget {
  const DeviceChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeviceChildCubit>(
      create: (_) => getIt<DeviceChildCubit>()..load(),
      child: BlocListener<DeviceChildCubit, DeviceChildState>(
        listener: (BuildContext context, DeviceChildState state) {
          if (state is DeviceChildChosen) {
            context.go(AppRoutePaths.home.path());
          }
        },
        child: AppScaffold(
          appBar: AppAppBar(
            onBack: () => context.go(AppRoutePaths.childSetup.path()),
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          body: BlocBuilder<DeviceChildCubit, DeviceChildState>(
            builder: (BuildContext context, DeviceChildState state) =>
                switch (state) {
                  DeviceChildLoading() => const AppSkeletonList(),
                  DeviceChildChosen() => const AppLoadingView(),
                  DeviceChildFailed(:final failure) => AppErrorView(
                    message: failureCopy(AppL10n.of(context), failure),
                    onRetry: context.read<DeviceChildCubit>().load,
                  ),
                  DeviceChildChoosing(:final choice) => DeviceChildBody(
                    choice: choice,
                    onChoose: context.read<DeviceChildCubit>().choose,
                  ),
                },
          ),
        ),
      ),
    );
  }
}
