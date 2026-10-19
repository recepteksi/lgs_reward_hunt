/// What has become of a task.
///
/// Derived from the task's own fields rather than stored, so a task cannot be
/// marked done while its completion timestamp is empty. `TaskEntity.statusAt`
/// is the only place the derivation lives.
///
/// [pending] is scheduled and still catchable. [completed] has been done and
/// paid for. [missed] is a task whose day has passed — not a punishment and
/// not an error, just a day that went differently.
enum TaskStatusEnum { pending, completed, missed }
