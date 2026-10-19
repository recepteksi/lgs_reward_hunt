import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keeps the mock backend's database on the device between launches.
///
/// The session is stored on the device, so the backend has to be as well:
/// a store that starts empty every launch while the session remembers a
/// parent sends every request for an account that no longer exists, and every
/// page fails. A real server keeps its rows. This makes the mock keep them too.
///
/// It writes to the same key-value store as the session. [load] fills `store`
/// and answers `true` when there is a saved database it can read. Anything
/// else, a first launch or an old or broken one, answers `false`, and the
/// caller seeds a new one. [save] writes the whole store after each change.
/// The mock is small enough that writing all of it costs less than working out
/// which part changed. A store that cannot be read or saved is logged, so a
/// dev build can tell why its household disappeared.
final class MockStoreArchive {
  const MockStoreArchive();

  static const String _key = 'mock.store';

  static const String _unreadable =
      'MockStoreArchive: the saved store could not be read; seeding a new one.';

  Future<bool> load(MockStore store) async {
    try {
      final String? saved = (await SharedPreferences.getInstance()).getString(
        _key,
      );
      if (saved == null) return false;
      final bool restored = store.restore(
        Map<String, Object?>.from(jsonDecode(saved) as Map<Object?, Object?>),
      );
      if (!restored) debugPrint(_unreadable);
      return restored;
    } catch (error) {
      debugPrint('$_unreadable $error');
      return false;
    }
  }

  Future<void> save(MockStore store) async {
    try {
      await (await SharedPreferences.getInstance()).setString(
        _key,
        jsonEncode(store.toJson()),
      );
    } catch (error) {
      debugPrint('MockStoreArchive: the store was not saved. $error');
    }
  }
}
