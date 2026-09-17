import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/child_snapshot_cache_interface.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_snapshot_read_model.dart';

/// The child snapshot, held in memory for the life of the app.
///
/// Memory is enough: the tabs are preloaded when the child shell opens, so the
/// only page that opens with nothing known is the very first one — and a
/// stored snapshot would be a stale name surviving a rename.
@LazySingleton(as: ChildSnapshotCacheInterface)
final class ChildSnapshotCacheRepository
    implements ChildSnapshotCacheInterface {
  ChildSnapshotCacheRepository();

  ChildSnapshotReadModel _snapshot = ChildSnapshotReadModel.empty;

  @override
  ChildSnapshotReadModel get snapshot => _snapshot;

  @override
  void write(ChildSnapshotReadModel snapshot) => _snapshot = snapshot;

  @override
  void forget() => _snapshot = ChildSnapshotReadModel.empty;
}
