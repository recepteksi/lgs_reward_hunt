import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lgs_reward_hunt/application/parent/cubit/parent/parent_cubit.dart';
import 'package:lgs_reward_hunt/domain/parent/read_models/parent_dashboard_read_model.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/state/app_empty_view.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/items/parent_approval_card.dart';

/// The requests waiting on the parent, oldest first — or a line saying there
/// are none, and that new ones will appear here.
///
/// [dashboard] supplies the requests, [isBusy] disables the answers while one
/// is on its way.
class ParentApprovalsSection extends StatelessWidget {
  const ParentApprovalsSection({
    required this.dashboard,
    required this.isBusy,
    super.key,
  });

  final ParentDashboardReadModel dashboard;

  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final ParentCubit cubit = context.read<ParentCubit>();

    if (dashboard.pending.isEmpty) {
      return AppEmptyView(
        message: l10n.parentNoApprovals,
        caption: l10n.parentNoApprovalsBody(dashboard.activeChild.name),
      );
    }

    return Column(
      children: <Widget>[
        for (final RedemptionEntity request in dashboard.pending) ...<Widget>[
          if (request != dashboard.pending.first)
            const SizedBox(height: AppSpacing.md),
          ParentApprovalCard(
            request: request,
            childName:
                dashboard.childOf(request)?.name ?? dashboard.activeChild.name,
            balanceAfter: dashboard.balance,
            onApprove: isBusy
                ? null
                : () => cubit.decide(request.id, approve: true),
            onReject: isBusy
                ? null
                : () => cubit.decide(request.id, approve: false),
          ),
        ],
      ],
    );
  }
}
