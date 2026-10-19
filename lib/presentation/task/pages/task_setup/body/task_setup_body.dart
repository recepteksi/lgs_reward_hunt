import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/task/cubit/task_setup/task_setup_cubit.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_kind_enum.dart';
import 'package:lgs_reward_hunt/domain/task/value_objects/task_plan_value_object.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_dashed_add_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_header.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_setup_step_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/task/pages/task_setup/items/task_setup_template_row.dart';

/// The task setup step's one body: the summary, the plan, and saving it.
///
/// Which line is open is kept here, one at a time — it is where the eye is,
/// not something the plan knows. Adding a line opens it, because a new line is
/// a line the parent is about to fill in.
///
/// The summary counts from the plan itself: lessons, chores, and what today is
/// worth by the same repeat rule the fortnight is written with. The primary
/// action cannot be pressed on an empty plan and says so, and waits while
/// [isSaving]. A refused save shows [failure] above it.
class TaskSetupBody extends StatefulWidget {
  const TaskSetupBody({
    required this.plan,
    this.isSaving = false,
    this.failure,
    super.key,
  });

  final TaskPlanValueObject plan;

  final bool isSaving;

  final Failure? failure;

  @override
  State<TaskSetupBody> createState() => _TaskSetupBodyState();
}

/// Holds which line is open.
class _TaskSetupBodyState extends State<TaskSetupBody> {
  String? _openId;

  @override
  void didUpdateWidget(TaskSetupBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    final List<TaskTemplateEntity> before = oldWidget.plan.templates;
    final List<TaskTemplateEntity> after = widget.plan.templates;
    if (after.length > before.length) {
      _openId = after.last.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final TaskSetupCubit cubit = context.read<TaskSetupCubit>();
    final TaskPlanValueObject plan = widget.plan;
    final Failure? failure = widget.failure;
    final DateTime today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const AppSetupHeader(step: AppSetupStepEnum.tasks),
        const SizedBox(height: AppSpacing.xl),
        Expanded(
          child: ListView(
            children: <Widget>[
              AppText(l10n.taskSetupTitle, type: AppTextTypeEnum.heading),
              const SizedBox(height: AppSpacing.sm),
              AppText(l10n.taskSetupBody, type: AppTextTypeEnum.body),
              const SizedBox(height: AppSpacing.lg),
              AppText(
                plan.isEmpty
                    ? l10n.taskSetupEmpty
                    : l10n.taskSetupSummary(
                        plan.countOf(TaskKindEnum.lesson),
                        plan.countOf(TaskKindEnum.chore),
                        plan.pointsOn(today, from: today),
                      ),
                type: AppTextTypeEnum.meta,
                weight: FontWeight.w800,
                color: palette.onSurfaceMuted,
              ),
              const SizedBox(height: AppSpacing.md),
              for (final TaskTemplateEntity template
                  in plan.templates) ...<Widget>[
                TaskSetupTemplateRow(
                  key: ValueKey<String>(template.id),
                  template: template,
                  isOpen: template.id == _openId,
                  onToggle: () => setState(
                    () => _openId = template.id == _openId ? null : template.id,
                  ),
                  onChanged: cubit.update,
                  onRemove: () => cubit.remove(template.id),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              AppDashedAddButton(
                label: l10n.taskSetupAdd,
                onPressed: cubit.add,
              ),
            ],
          ),
        ),
        if (failure != null) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          AppText(
            failureCopy(l10n, failure),
            type: AppTextTypeEnum.caption,
            color: palette.errorInk,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppButton.filled(
          label: plan.isEmpty ? l10n.taskSetupNeedOne : l10n.commonContinue,
          isExpanded: true,
          onPressed: plan.isEmpty || widget.isSaving ? null : cubit.save,
        ),
      ],
    );
  }
}
