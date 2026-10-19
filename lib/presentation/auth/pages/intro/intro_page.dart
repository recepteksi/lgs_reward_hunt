import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/presentation/auth/pages/intro/body/intro_body.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/router/app_route_paths.dart';

/// Three slides that say what the app is before anyone is asked for an email.
///
/// There is no Cubit: nothing here calls a use case, and which slide is showing
/// is the body's own business, not application state. Skipping and finishing
/// lead to the same place — the account step — and replace the intro rather
/// than stacking on it, because the back gesture from the sign-up form should
/// not replay a tour the parent has already dismissed.
class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: const EdgeInsets.all(AppSpacing.xl),
      body: IntroBody(onFinish: () => context.go(AppRoutePaths.auth.path())),
    );
  }
}
