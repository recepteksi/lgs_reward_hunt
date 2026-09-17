import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/parent/cubit/parent/parent_cubit.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/parent/read_models/parent_dashboard_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/items/parent_child_chip.dart';

/// Which child this device is on, for a household of more than one.
///
/// Each child keeps their own map, points and streak on the server; switching
/// is choosing whose the tabs show, and everything on this page follows.
/// [dashboard] supplies the children, [isBusy] disables switching mid-action.
class ParentChildSwitch extends StatelessWidget {
  const ParentChildSwitch({
    required this.dashboard,
    required this.isBusy,
    super.key,
  });

  final ParentDashboardReadModel dashboard;

  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final ParentCubit cubit = context.read<ParentCubit>();

    return AppCard(
      radius: AppRadii.xl,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppText(
            AppL10n.of(context).parentActiveChildLabel,
            type: AppTextTypeEnum.label,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              for (final ChildEntity child
                  in dashboard.household.children) ...<Widget>[
                if (child != dashboard.household.children.first)
                  const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ParentChildChip(
                    child: child,
                    avatar: dashboard.household.avatarOf(child),
                    isSelected: child.id == dashboard.activeChild.id,
                    onTap: isBusy || child.id == dashboard.activeChild.id
                        ? null
                        : () => cubit.chooseChild(child.id),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
