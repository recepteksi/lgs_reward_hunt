import 'package:lgs_reward_hunt/domain/parent/enums/parent_notice_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns a [ParentNoticeEnum] into the toast that confirms it — the one place
/// that mapping happens.
String parentNoticeCopy(AppL10n l10n, ParentNoticeEnum notice) =>
    switch (notice) {
      ParentNoticeEnum.approved => l10n.parentNoticeApproved,
      ParentNoticeEnum.rejected => l10n.parentNoticeRejected,
      ParentNoticeEnum.rewardAdded => l10n.parentNoticeRewardAdded,
      ParentNoticeEnum.tasksAdded => l10n.parentNoticeTasksAdded,
      ParentNoticeEnum.taskSaved => l10n.parentNoticeTaskSaved,
      ParentNoticeEnum.taskRemoved => l10n.parentNoticeTaskRemoved,
    };
