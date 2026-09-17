import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/parent_gate/parent_gate_cubit.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/parent_gate/body/parent_gate_body.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_app_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';

/// The PIN between a child's tabs and the parent's side.
///
/// It opens over the tab it came from; the back arrow returns there. The right
/// code replaces the gate with the parent's page, so backing out of the
/// parent's side does not land on a keypad that has already been passed.
class ParentGatePage extends StatelessWidget {
  const ParentGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ParentGateCubit>(
      create: (_) => getIt<ParentGateCubit>(),
      child: BlocListener<ParentGateCubit, ParentGateState>(
        listener: (BuildContext context, ParentGateState state) {
          if (state is ParentGateOpened) {
            context.pushReplacement(AppRoutePaths.parent.path());
          }
        },
        child: AppScaffold(
          appBar: AppAppBar(onBack: () => context.pop()),
          padding: const EdgeInsets.all(AppSpacing.xl),
          body: BlocBuilder<ParentGateCubit, ParentGateState>(
            builder: (BuildContext context, ParentGateState state) =>
                ParentGateBody(state: state),
          ),
        ),
      ),
    );
  }
}
