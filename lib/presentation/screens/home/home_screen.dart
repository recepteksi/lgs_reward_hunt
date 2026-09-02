import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/di/injection.dart';
import 'package:lgs_reward_hunt/application/exam/exam_countdown_cubit.dart';
import 'package:lgs_reward_hunt/application/exam/exam_countdown_state.dart';
import 'package:lgs_reward_hunt/presentation/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/theme/app_spacing.dart';

/// The one example screen: the LGS countdown.
///
/// It exists to show the shape every other screen will take, not to be the
/// finished home. Reading down: the screen resolves its Cubit from the
/// container and starts it, and renders one branch per state. It computes
/// nothing — how many days are left is the entity's question, and which words
/// a failure gets is [failureCopy]'s.
///
/// The `switch` over the state is exhaustive because the state is `sealed`, so
/// a state added later cannot quietly render as a blank screen here.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);

    return BlocProvider<ExamCountdownCubit>(
      // Created here and disposed with the route, which is what cancels the
      // Cubit's ticker: a timer owned by a screen has to die with it.
      create: (_) => getIt<ExamCountdownCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.appTitle)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: BlocBuilder<ExamCountdownCubit, ExamCountdownState>(
                builder: (context, state) => switch (state) {
                  ExamCountdownIdle() || ExamCountdownLoading() =>
                    const CircularProgressIndicator(),
                  ExamCountdownLoaded(:final countdown) => _Countdown(
                      days: countdown.daysRemaining,
                      examDate: countdown.examDate,
                    ),
                  ExamCountdownError(:final failure) => _ErrorView(
                      message: failureCopy(l10n, failure),
                      onRetry: () => context.read<ExamCountdownCubit>().load(),
                    ),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The countdown itself, once there is one to show.
class _Countdown extends StatelessWidget {
  const _Countdown({required this.days, required this.examDate});

  final int days;
  final DateTime examDate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(l10n.countdownTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.countdownDays(days),
          style: theme.textTheme.displayMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.countdownExamDate(examDate),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// What the screen shows when the date could not be read.
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          message,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: onRetry,
          child: Text(AppL10n.of(context).commonRetry),
        ),
      ],
    );
  }
}
