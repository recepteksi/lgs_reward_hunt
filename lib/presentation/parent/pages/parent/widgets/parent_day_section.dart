import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lgs_reward_hunt/application/parent/cubit/parent/parent_cubit.dart';
import 'package:lgs_reward_hunt/domain/parent/read_models/parent_dashboard_read_model.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/section/app_section_header.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/items/parent_day_chip.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/items/parent_task_row.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/modal_bottom_sheet/parent_task_sheet.dart';

/// The week ahead, a day at a time: pick a day, see its tasks, change them.
///
/// Tapping a task opens it in the task sheet; the button under the list opens
/// the sheet for a new one on the selected day. What the sheet decides goes to
/// the Cubit, which writes it and reads the week again. [dashboard] supplies
/// the week, [day] is the selected day and [onDayChanged] picks another;
/// [isBusy] disables changes while one is on its way.
class ParentDaySection extends StatelessWidget {
  const ParentDaySection({
    required this.dashboard,
    required this.day,
    required this.isBusy,
    required this.onDayChanged,
    super.key,
  });

  final ParentDashboardReadModel dashboard;

  final DateTime day;

  final bool isBusy;

  final ValueChanged<DateTime> onDayChanged;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final AppPalette palette = AppPalette.of(context);
    final String locale = Localizations.localeOf(context).toLanguageTag();
    final List<TaskEntity> tasks = dashboard.tasksOn(day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppSectionHeader(
          title: l10n.parentDayTasks(DateFormat.EEEE(locale).format(day)),
          trailing: l10n.parentTapToEdit,
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              for (final DateTime option in dashboard.days) ...<Widget>[
                if (option != dashboard.days.first)
                  const SizedBox(width: AppSpacing.sm),
                ParentDayChip(
                  day: option,
                  today: dashboard.today,
                  taskCount: dashboard.tasksOn(option).length,
                  isSelected: option == day,
                  onTap: () => onDayChanged(option),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          radius: AppRadii.xxl,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final TaskEntity task in tasks) ...<Widget>[
                ParentTaskRow(
                  task: task,
                  onTap: isBusy || task.isCompleted
                      ? null
                      : () => _open(context, task),
                ),
                Divider(height: AppSizes.border, color: palette.outline),
              ],
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: AppButton.text(
                  label: l10n.taskSetupAdd,
                  icon: AppIcons.plus,
                  onPressed: isBusy ? null : () => _open(context, null),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _open(BuildContext context, TaskEntity? task) {
    final ParentCubit cubit = context.read<ParentCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppPalette.of(context).background,
      builder: (_) => ParentTaskSheet(
        day: day,
        task: task,
        onAdd: (template, end) =>
            cubit.addTask(template: template, day: day, end: end),
        onSave: (template) =>
            cubit.updateTask(taskId: task!.id, template: template, day: day),
        onDelete: () => cubit.deleteTask(task!.id),
      ),
    );
  }
}
