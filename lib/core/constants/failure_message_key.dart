/// Every key a `Failure` can carry, in one place.
///
/// A key typed at the throw site is not checked by anything: the lookup that
/// resolves it answers a miss by echoing what it was asked, so a typo reaches
/// the user as a dotted identifier and nothing logs a problem. Named here, a
/// wrong one does not compile.
///
/// These are keys, not copy. The words live in the ARB catalogues.
///
/// [network] is no route to the server — the device is offline or the network
/// refused. [unexpectedResponse] is a server that answered, but with something
/// we cannot use. [unauthorized] is a missing or expired session. [unknown] is
/// anything with no better explanation.
///
/// [examDateMissing] is an exam date not configured for the current year.
///
/// [signInCancelled] is a platform sign-in sheet closed by the parent — not an
/// error, nothing to show. [platformSignInFailed] is one the platform refused.
/// [pinWrong] is a parent PIN that does not match the one set.
///
/// Account: [parentNameEmpty] and [childNameEmpty] are blank names.
/// [childGradeInvalid] is a grade the app is not for, [childAvatarMissing] a
/// child added without a face, and [childLimitReached] a household already
/// holding `AccountRules.maxChildren`.
/// [linkCodeInvalid] is a code that matches no parent, [linkCodeUsed] one that
/// has already tied a child to a parent.
///
/// Tasks: [taskTitleEmpty] is a task with no title, [taskPointsInvalid] a
/// reward outside the allowed range, [taskDurationInvalid] a duration outside
/// it. [taskAlreadyCompleted] is a second completion of the same task —
/// refused, because paying twice for one task is how the ledger stops
/// balancing. [taskNotToday] is a completion attempt on a day that is not the
/// task's own.
///
/// Task plan: [taskPlanEmpty] is a plan with no tasks in it,
/// [taskCategoryInvalid] a category that does not belong to the task's kind,
/// and [taskTimeInvalid] a start time outside the day.
///
/// Rewards: [rewardNameEmpty] and [rewardCostInvalid] are a malformed reward.
/// [rewardPoolEmpty] is a reward pool saved with nothing in it.
/// [insufficientPoints] is a redemption the balance cannot cover.
/// [redemptionNotPending] is an approve or reject on a redemption that has
/// already been decided.
abstract final class FailureMessageKey {
  static const String network = 'failure_network';
  static const String unexpectedResponse = 'failure_unexpected_response';
  static const String unauthorized = 'failure_unauthorized';
  static const String unknown = 'failure_unknown';

  static const String storageUnavailable = 'failure_storage_unavailable';

  static const String examDateMissing = 'failure_exam_date_missing';

  static const String emailInvalid = 'failure_email_invalid';

  static const String passwordTooShort = 'failure_password_too_short';

  static const String passwordTooWeak = 'failure_password_too_weak';

  static const String credentialsInvalid = 'failure_credentials_invalid';

  static const String emailInUse = 'failure_email_in_use';

  static const String pinInvalid = 'failure_pin_invalid';

  static const String pinMismatch = 'failure_pin_mismatch';

  static const String pinWrong = 'failure_pin_wrong';

  static const String notSignedIn = 'failure_not_signed_in';

  static const String signInCancelled = 'failure_sign_in_cancelled';

  static const String platformSignInFailed = 'failure_platform_sign_in_failed';

  static const String parentNameEmpty = 'failure_parent_name_empty';
  static const String childNameEmpty = 'failure_child_name_empty';
  static const String childGradeInvalid = 'failure_child_grade_invalid';
  static const String childAvatarMissing = 'failure_child_avatar_missing';
  static const String childLimitReached = 'failure_child_limit_reached';
  static const String linkCodeInvalid = 'failure_link_code_invalid';
  static const String linkCodeUsed = 'failure_link_code_used';

  static const String taskTitleEmpty = 'failure_task_title_empty';
  static const String taskPointsInvalid = 'failure_task_points_invalid';
  static const String taskDurationInvalid = 'failure_task_duration_invalid';
  static const String taskAlreadyCompleted = 'failure_task_already_completed';
  static const String taskNotToday = 'failure_task_not_today';
  static const String taskPlanEmpty = 'failure_task_plan_empty';
  static const String taskCategoryInvalid = 'failure_task_category_invalid';
  static const String taskTimeInvalid = 'failure_task_time_invalid';

  static const String rewardNameEmpty = 'failure_reward_name_empty';
  static const String rewardCostInvalid = 'failure_reward_cost_invalid';
  static const String rewardPoolEmpty = 'failure_reward_pool_empty';
  static const String insufficientPoints = 'failure_insufficient_points';
  static const String redemptionNotPending = 'failure_redemption_not_pending';
}
