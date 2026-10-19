import 'package:lgs_reward_hunt/domain/account/read_models/child_snapshot_read_model.dart';

/// Where the last-read child snapshot is kept for the next page to open with.
///
/// [snapshot] is read synchronously — it is what a loading state shows, and a
/// loading state cannot wait. [write] replaces it; [forget] clears it when the
/// child on screen changes, so one child's name never opens another's page.
abstract interface class ChildSnapshotCacheInterface {
  ChildSnapshotReadModel get snapshot;

  void write(ChildSnapshotReadModel snapshot);

  void forget();
}
