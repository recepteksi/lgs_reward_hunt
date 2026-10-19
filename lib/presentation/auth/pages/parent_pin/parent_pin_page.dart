import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/parent_pin/parent_pin_cubit.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/parent_pin/body/parent_pin_body.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_app_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_loading_view.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';

/// Setting the four digits that guard the parent's side.
///
/// Two passes, one keypad. The screen changes its words between them and
/// nothing else — a second, differently-shaped screen for "type it again" would
/// suggest something else is being asked for.
///
/// The app bar's back arrow follows the passes too: on the second pass it goes
/// back to the first, as the design does, and only on the first does it leave
/// the page. Which of the two it is is the Cubit's answer, through `stepBack`.
class ParentPinPage extends StatelessWidget {
  const ParentPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ParentPinCubit>(
      create: (_) => getIt<ParentPinCubit>(),
      child: BlocListener<ParentPinCubit, ParentPinState>(
        listener: (BuildContext context, ParentPinState state) {
          if (state is ParentPinSet) {
            context.go(AppRoutePaths.childSetup.path());
          }
        },
        child: Builder(
          builder: (BuildContext context) => AppScaffold(
            appBar: AppAppBar(
              onBack: () {
                if (!context.read<ParentPinCubit>().stepBack()) context.pop();
              },
            ),
            padding: const EdgeInsets.all(AppSpacing.xl),
            body: BlocBuilder<ParentPinCubit, ParentPinState>(
              builder: (BuildContext context, ParentPinState state) =>
                  switch (state) {
                    ParentPinSubmitting() ||
                    ParentPinSet() => const AppLoadingView(),
                    ParentPinEntering(:final digits, :final isRepeat) =>
                      ParentPinBody(digits: digits, isRepeat: isRepeat),
                    ParentPinFailed(:final failure) => ParentPinBody(
                      digits: CharConstants.empty,
                      isRepeat: false,
                      failure: failure,
                    ),
                  },
            ),
          ),
        ),
      ),
    );
  }
}
