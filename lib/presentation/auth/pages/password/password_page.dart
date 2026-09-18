import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/password/password_cubit.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/password/body/password_body.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_app_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_loading_view.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:lgs_reward_hunt/presentation/router/arguments/password_arguments_model.dart';

/// Choosing the password, and with it creating the account.
///
/// The checklist under the field is the reason this is a screen rather than one
/// more field on the last one: three rules, ticking as they are met, is a
/// different amount of space and a different amount of attention.
///
/// [arguments] carries the name and the email from the previous step.
class PasswordPage extends StatelessWidget {
  const PasswordPage({required this.arguments, super.key});

  final PasswordArgumentsModel arguments;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PasswordCubit>(
      create: (_) => getIt<PasswordCubit>(),
      child: BlocListener<PasswordCubit, PasswordState>(
        listener: (BuildContext context, PasswordState state) {
          if (state is PasswordCreated) {
            context.push(AppRoutePaths.parentPin.path());
          }
        },
        child: AppScaffold(
          appBar: AppAppBar(onBack: () => context.pop()),
          padding: const EdgeInsets.all(AppSpacing.xl),
          body: BlocBuilder<PasswordCubit, PasswordState>(
            builder: (BuildContext context, PasswordState state) =>
                switch (state) {
                  PasswordSubmitting() ||
                  PasswordCreated() => const AppLoadingView(),
                  PasswordEditing() => PasswordBody(arguments: arguments),
                  PasswordFailed(:final failure) => PasswordBody(
                    arguments: arguments,
                    failure: failure,
                  ),
                },
          ),
        ),
      ),
    );
  }
}
