/// What the parent's last action did, for the page to confirm in a toast.
///
/// [approved] and [rejected] answer a request, [rewardAdded] put a reward in
/// the pool, [tasksAdded] wrote a task, [taskSaved] changed one and
/// [taskRemoved] took one away. Anything else — a price step, a switch, a
/// different child — shows itself on the page and needs no toast.
enum ParentNoticeEnum {
  approved,
  rejected,
  rewardAdded,
  tasksAdded,
  taskSaved,
  taskRemoved,
}
