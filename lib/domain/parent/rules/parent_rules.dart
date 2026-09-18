/// How much the parent's side shows at once.
///
/// [dayStripDays] is the days a parent can plan from the approvals tab: this
/// week ahead, starting today. Further out is the task plan's job.
abstract final class ParentRules {
  static const int dayStripDays = 7;
}
