import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/parent/read_models/parent_dashboard_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/failure_copy.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/parent_tab_enum.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/widgets/parent_approvals_section.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/widgets/parent_child_switch.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/widgets/parent_child_today_card.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/widgets/parent_day_section.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/widgets/parent_pool_section.dart';
import 'package:lgs_reward_hunt/presentation/parent/pages/parent/widgets/parent_tab_switch.dart';

/// The parent page's one body.
///
/// Which tab and which day of the strip are showing are kept here — they are
/// where the parent is looking, not something the dashboard knows — and stay
/// put when the dashboard comes back after an action. [dashboard] is what to
/// show, [isBusy] disables the controls while an action is on its way, and
/// [failure] is a refused one, shown at the top.
class ParentBody extends StatefulWidget {
  const ParentBody({
    required this.dashboard,
    required this.isBusy,
    this.failure,
    super.key,
  });

  final ParentDashboardReadModel dashboard;

  final bool isBusy;

  final Failure? failure;

  @override
  State<ParentBody> createState() => _ParentBodyState();
}

/// Holds the tab and the selected day.
class _ParentBodyState extends State<ParentBody> {
  ParentTabEnum _tab = ParentTabEnum.approvals;

  late DateTime _day = widget.dashboard.today;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = AppL10n.of(context);
    final ParentDashboardReadModel dashboard = widget.dashboard;
    final Failure? failure = widget.failure;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxxl,
      ),
      children: <Widget>[
        if (failure != null) ...<Widget>[
          AppText(
            failureCopy(l10n, failure),
            type: AppTextTypeEnum.caption,
            color: AppPalette.of(context).errorInk,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        if (dashboard.hasSeveralChildren) ...<Widget>[
          ParentChildSwitch(dashboard: dashboard, isBusy: widget.isBusy),
          const SizedBox(height: AppSpacing.md),
        ],
        ParentChildTodayCard(dashboard: dashboard),
        const SizedBox(height: AppSpacing.md),
        ParentTabSwitch(
          selected: _tab,
          onChanged: (ParentTabEnum tab) => setState(() => _tab = tab),
        ),
        const SizedBox(height: AppSpacing.md),
        ...switch (_tab) {
          ParentTabEnum.approvals => <Widget>[
            ParentApprovalsSection(dashboard: dashboard, isBusy: widget.isBusy),
            const SizedBox(height: AppSpacing.xl),
            ParentDaySection(
              dashboard: dashboard,
              day: _day,
              isBusy: widget.isBusy,
              onDayChanged: (DateTime day) => setState(() => _day = day),
            ),
          ],
          ParentTabEnum.pool => <Widget>[
            ParentPoolSection(dashboard: dashboard, isBusy: widget.isBusy),
          ],
        },
      ],
    );
  }
}
