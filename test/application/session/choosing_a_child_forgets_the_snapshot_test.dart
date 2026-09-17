import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_reward_hunt/application/session/use_cases/choose_device_child_use_case.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_snapshot_read_model.dart';
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart';
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Switching the device to another child never opens a page with the previous
/// child's name or balance.
void main() {
  test(
    'choosing another child forgets what was known about the last',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'session.parentId': 'p1',
        'session.activeChildId': 'c1',
      });
      final ChildSnapshotCacheRepository snapshots =
          ChildSnapshotCacheRepository()
            ..write(ChildSnapshotReadModel.empty.withBalance(480));

      await ChooseDeviceChildUseCase(const SessionRepository(), snapshots)(
        'c2',
      );

      expect(snapshots.snapshot, ChildSnapshotReadModel.empty);
    },
  );
}
