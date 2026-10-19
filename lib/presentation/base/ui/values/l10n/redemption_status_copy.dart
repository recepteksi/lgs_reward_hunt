import 'package:lgs_reward_hunt/domain/reward/enums/redemption_status_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns a [RedemptionStatusEnum] into the word on its badge — the one place
/// that mapping happens. A refusal reads "Şimdi olmaz", not "rejected": a
/// parent's no is about now.
String redemptionStatusCopy(AppL10n l10n, RedemptionStatusEnum status) =>
    switch (status) {
      RedemptionStatusEnum.pending => l10n.redemptionPending,
      RedemptionStatusEnum.approved => l10n.redemptionApproved,
      RedemptionStatusEnum.rejected => l10n.redemptionRejected,
    };
