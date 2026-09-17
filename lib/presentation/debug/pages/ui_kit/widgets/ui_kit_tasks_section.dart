import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/task/app_task_row.dart';
import 'package:lgs_reward_hunt/presentation/debug/pages/ui_kit/widgets/ui_kit_panel.dart';

/// Section 05: a task row in its three states.
///
/// Stacked in the order a day is actually read — one waiting, one done, one not
/// open yet — because the states are only right in each other's company: the
/// done row has to be the brightest thing in the list without turning the list
/// into a scoreboard, and the locked row has to read as "not yet" rather than
/// as "broken".
///
/// The content is real LGS material from the design, not placeholder: a subject
/// and topic pair is the longest string these rows will ever have to hold.
class UiKitTasksSection extends StatelessWidget {
  const UiKitTasksSection({super.key});

  static const int _pendingPoints = 20;

  static const int _donePoints = 20;

  static const int _lockedPoints = 15;

  @override
  Widget build(BuildContext context) {
    return const UiKitPanel(
      children: <Widget>[
        AppTaskRow.pending(
          title: 'Kareköklü ifadeler',
          meta: 'Matematik · 19:00 · 30 dk',
          points: _pendingPoints,
        ),
        AppTaskRow.done(
          title: 'Basınç · deneme testi',
          meta: 'Fen Bilimleri · 17:30 · 25 dk',
          points: _donePoints,
        ),
        AppTaskRow.locked(
          title: 'Millî Uyanış',
          meta: 'İnkılap Tarihi · yarın açılıyor',
          points: _lockedPoints,
        ),
        SizedBox(height: AppSpacing.xs),
      ],
    );
  }
}
