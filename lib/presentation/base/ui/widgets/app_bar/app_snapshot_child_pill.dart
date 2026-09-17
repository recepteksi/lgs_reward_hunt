import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_header_read_model.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_child_pill.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/app_bar/app_child_pill_skeleton.dart';

/// The child pill of a tab that is still loading: the real pill when the
/// child is already known ([header]), its skeleton when not.
///
/// The subtitle is the grade — the one line every tab can say before its own
/// data arrives.
class AppSnapshotChildPill extends StatelessWidget {
  const AppSnapshotChildPill({required this.header, super.key});

  final ChildHeaderReadModel? header;

  @override
  Widget build(BuildContext context) {
    final ChildHeaderReadModel? header = this.header;
    if (header == null) return const AppChildPillSkeleton();

    return AppChildPill(
      name: header.child.name,
      avatar: header.avatar,
      subtitle: AppL10n.of(context).childGrade(header.child.gradeLevel),
    );
  }
}
