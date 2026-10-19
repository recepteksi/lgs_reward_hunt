import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lgs_reward_hunt/application/account/cubit/child_form/child_form_cubit.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/presentation/account/pages/child_form/body/child_form_body.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_app_bar.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/scaffold/app_scaffold.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_loading_view.dart';

/// Adding one child: a name, a grade, and a face from the catalogue.
///
/// It opens over the child setup list and closes back onto it, both when the
/// child is saved and when the parent backs out; the list reloads either way.
/// The catalogue starts loading as the page opens, so by the time a name has
/// been typed the faces are usually there.
///
/// The body is on screen in every state but the saved one, and it keeps what
/// the parent picked across the others — a failed save does not clear the form.
class ChildFormPage extends StatelessWidget {
  const ChildFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChildFormCubit>(
      create: (_) => getIt<ChildFormCubit>()..loadAvatars(),
      child: BlocListener<ChildFormCubit, ChildFormState>(
        listener: (BuildContext context, ChildFormState state) {
          if (state is ChildFormSaved) context.pop();
        },
        child: AppScaffold(
          appBar: AppAppBar(onBack: () => context.pop()),
          padding: const EdgeInsets.all(AppSpacing.xl),
          body: BlocBuilder<ChildFormCubit, ChildFormState>(
            builder: (BuildContext context, ChildFormState state) =>
                switch (state) {
                  ChildFormSaved() => const AppLoadingView(),
                  ChildFormLoadingAvatars() ||
                  ChildFormAvatarsFailed() ||
                  ChildFormReady() ||
                  ChildFormSaving() ||
                  ChildFormSaveFailed() => ChildFormBody(state: state),
                },
          ),
        ),
      ),
    );
  }
}
