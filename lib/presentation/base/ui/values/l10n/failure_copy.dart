import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';

/// Turns a [Failure] into words a user can read.
///
/// The ONLY place that mapping happens. A `Failure` carries a key, never a
/// sentence, so the layer that produced it never has to know the user's
/// language — and copy can be reworded without touching a use case.
///
/// The `switch` is on the key rather than on the type because two failures of
/// the same class can need opposite advice: "you are offline" and "the server
/// sent nonsense" are both worth saying differently, and both arrive as the
/// same Dart type.
///
/// An unrecognised key falls back to the generic sentence rather than showing
/// the key itself: a dotted identifier on screen is worse than a vague
/// sentence, and it is what happens when a lookup answers a miss by echoing its
/// input.
String failureCopy(
  AppL10n l10n,
  Failure failure,
) => switch (failure.messageKey) {
  FailureMessageKey.network => l10n.failureNetwork,
  FailureMessageKey.unexpectedResponse => l10n.failureUnexpectedResponse,
  FailureMessageKey.examDateMissing => l10n.failureExamDateMissing,
  FailureMessageKey.storageUnavailable => l10n.failureStorageUnavailable,
  FailureMessageKey.emailInvalid => l10n.failureEmailInvalid,
  FailureMessageKey.passwordTooShort => l10n.failurePasswordTooShort,
  FailureMessageKey.passwordTooWeak => l10n.failurePasswordTooWeak,
  FailureMessageKey.credentialsInvalid => l10n.failureCredentialsInvalid,
  FailureMessageKey.emailInUse => l10n.failureEmailInUse,
  FailureMessageKey.pinInvalid => l10n.failurePinInvalid,
  FailureMessageKey.pinMismatch => l10n.failurePinMismatch,
  FailureMessageKey.pinWrong => l10n.failurePinWrong,
  FailureMessageKey.platformSignInFailed => l10n.failurePlatformSignInFailed,
  FailureMessageKey.signInCancelled => l10n.failureSignInCancelled,
  FailureMessageKey.notSignedIn => l10n.failureNotSignedIn,
  FailureMessageKey.childNameEmpty => l10n.failureChildNameEmpty,
  FailureMessageKey.childGradeInvalid => l10n.failureChildGradeInvalid,
  FailureMessageKey.childAvatarMissing => l10n.failureChildAvatarMissing,
  FailureMessageKey.childLimitReached => l10n.failureChildLimitReached,
  FailureMessageKey.taskPlanEmpty => l10n.failureTaskPlanEmpty,
  FailureMessageKey.taskTitleEmpty => l10n.failureTaskTitleEmpty,
  FailureMessageKey.taskPointsInvalid => l10n.failureTaskPointsInvalid,
  FailureMessageKey.taskDurationInvalid => l10n.failureTaskDurationInvalid,
  FailureMessageKey.taskCategoryInvalid => l10n.failureTaskCategoryInvalid,
  FailureMessageKey.taskTimeInvalid => l10n.failureTaskTimeInvalid,
  FailureMessageKey.rewardPoolEmpty => l10n.failureRewardPoolEmpty,
  FailureMessageKey.rewardNameEmpty => l10n.failureRewardNameEmpty,
  FailureMessageKey.rewardCostInvalid => l10n.failureRewardCostInvalid,
  FailureMessageKey.insufficientPoints => l10n.failureInsufficientPoints,
  FailureMessageKey.redemptionNotPending => l10n.failureRedemptionNotPending,
  _ => l10n.failureUnknown,
};
