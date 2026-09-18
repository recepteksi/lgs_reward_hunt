import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/auth/cubit/auth/auth_cubit.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/auth/body/auth_body.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_loading_view.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';
import 'package:lgs_reward_hunt/presentation/router/arguments/password_arguments_model.dart';

/// The parent's account: a new one, or one they already have.
///
/// It is the only screen in setup that can end two ways, so it is the only one
/// that listens as well as builds. Signing in finishes the flow here; signing
/// up hands the name and the email to the password screen, which is where the
/// account is actually made. Google and Apple end either way: a returning
/// parent opens on the map (or on child setup, with no child yet), a new one
/// goes on to set a PIN.
///
/// The `switch` over [AuthState] is exhaustive, so a state added later cannot
/// render as a blank screen.
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: _onState,
        child: AppScaffold(
          padding: const EdgeInsets.all(AppSpacing.xl),
          body: BlocBuilder<AuthCubit, AuthState>(
            builder: (BuildContext context, AuthState state) => switch (state) {
              AuthSubmitting() => const AppLoadingView(),
              AuthEditing(:final isSignUp) => AuthBody(isSignUp: isSignUp),
              AuthFailed(:final failure) => AuthBody(
                isSignUp: true,
                failure: failure,
              ),
              AuthSignedIn() ||
              AuthNeedsPassword() ||
              AuthNeedsPin() => const AppLoadingView(),
            },
          ),
        ),
      ),
    );
  }

  void _onState(BuildContext context, AuthState state) {
    switch (state) {
      case AuthNeedsPassword(:final name, :final email):
        context.push(
          AppRoutePaths.password.path(),
          extra: PasswordArgumentsModel(name: name, email: email),
        );
      case AuthSignedIn(:final hasChild):
        context.go(
          hasChild
              ? AppRoutePaths.home.path()
              : AppRoutePaths.childSetup.path(),
        );
      case AuthNeedsPin():
        context.go(AppRoutePaths.parentPin.path());
      case AuthEditing() || AuthSubmitting() || AuthFailed():
        break;
    }
  }
}
