/// Every endpoint the app calls, built in one place.
///
/// Written as functions rather than string constants with an id glued on at
/// the call site: a path assembled by hand is a path that drifts, and the mock
/// router matches these same shapes, so a route spelled two ways silently
/// stops matching and the app sees a 404 nobody wrote.
///
/// There is no backend yet. These are the endpoints the real one will have,
/// and the mock answers them today, so the day a server appears the only thing
/// that changes is the base URL.
abstract final class ApiPaths {
  static const String authSignUp = '/auth/sign-up';

  static const String authSignIn = '/auth/sign-in';

  static const String authPlatform = '/auth/platform';

  static const String avatars = '/avatars';

  static const String parents = '/parents';

  static String parent(String parentId) => '$parents/$parentId';

  static String childrenOfParent(String parentId) =>
      '${parent(parentId)}/children';

  static String parentPin(String parentId) => '$parents/$parentId/pin';

  static String parentPinVerify(String parentId) =>
      '${parentPin(parentId)}/verify';

  static const String childLink = '/children/link';

  static String child(String childId) => '/children/$childId';

  static String tasksOfChild(String childId) => '${child(childId)}/tasks';

  static String task(String taskId) => '/tasks/$taskId';

  static String completeTask(String taskId) => '${task(taskId)}/complete';

  static String taskSeriesOfChild(String childId) =>
      '${tasksOfChild(childId)}/series';

  static String reward(String rewardId) => '/rewards/$rewardId';

  static const String standardTaskPlan = '/task-plans/standard';

  static const String standardRewardPool = '/reward-pools/standard';

  static String rewardPoolOfParent(String parentId) =>
      '${parent(parentId)}/reward-pool';

  static String taskPlanOfParent(String parentId) =>
      '${parent(parentId)}/task-plan';

  static String rewardsOfParent(String parentId) =>
      '$parents/$parentId/rewards';

  static String redemptionsOfChild(String childId) =>
      '${child(childId)}/redemptions';

  static String redemptionsOfParent(String parentId) =>
      '$parents/$parentId/redemptions';

  static String approveRedemption(String id) => '/redemptions/$id/approve';

  static String rejectRedemption(String id) => '/redemptions/$id/reject';

  static String pointsOfChild(String childId) => '${child(childId)}/points';

  static const String dayQuery = 'day';

  static const String fromQuery = 'from';

  static const String toQuery = 'to';
}
