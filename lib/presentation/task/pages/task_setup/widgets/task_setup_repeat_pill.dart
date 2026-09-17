import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';
import 'package:lgs_reward_hunt/domain/task/enums/task_kind_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/task_repeat_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// How often a line of the plan comes back, as a small pill.
///
/// A chore's pill is tinted with the primary container and a lesson's is the
/// neutral high surface, so the two kinds separate down the list without a
/// heading between them. [template] supplies both the rhythm and the kind.
class TaskSetupRepeatPill extends StatelessWidget {
  const TaskSetupRepeatPill({required this.template, super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final bool isChore = template.kind == TaskKindEnum.chore;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isChore ? palette.primaryContainer : palette.surfaceHigh,
        borderRadius: BorderRadius.circular(AppRadii.round),
      ),
      child: AppText(
        taskRepeatCopy(AppL10n.of(context), template.repeat),
        type: AppTextTypeEnum.caption,
        weight: FontWeight.w800,
        color: isChore ? palette.onPrimaryContainer : palette.onSurfaceVariant,
      ),
    );
  }

  final TaskTemplateEntity template;
}
