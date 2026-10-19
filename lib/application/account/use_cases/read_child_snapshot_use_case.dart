import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/child_snapshot_cache_interface.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_snapshot_read_model.dart';

/// What a child page can show before it has loaded anything.
///
/// Synchronous on purpose: a Cubit calls it while emitting its loading state,
/// so the app bar opens with the child's name and balance instead of a
/// skeleton whenever another tab has already read them.
@injectable
final class ReadChildSnapshotUseCase {
  const ReadChildSnapshotUseCase(this._cache);

  final ChildSnapshotCacheInterface _cache;

  ChildSnapshotReadModel call() => _cache.snapshot;
}
