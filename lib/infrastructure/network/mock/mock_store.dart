/// The mock backend's database: rows, in memory, for the life of the process.
///
/// Rows are plain JSON maps, exactly what a real server would send. That is
/// the point of storing them this way rather than as entities — the
/// repositories do their real parsing against real payloads, so the day a
/// server appears the mapping has already been exercised instead of being
/// written for the first time against production.
///
/// Every collection is public and mutable because the router is the only thing
/// that touches it and hiding that behind methods would be ceremony. What is
/// NOT public is [nextId]: ids handed out twice are the one corruption a store
/// this simple can suffer.
///
/// [reset] exists for tests, which need a store that has not been played with
/// by the last one.
///
/// The helpers at the bottom are the store operations more than one handler
/// needs: [childIdsOf] a household's children, [addLedger] a points entry,
/// [issueLinkCode] a fresh code, [sameDay] a calendar-day comparison.
final class MockStore {
  final List<Map<String, Object?>> parents = <Map<String, Object?>>[];
  final List<Map<String, Object?>> children = <Map<String, Object?>>[];
  final List<Map<String, Object?>> tasks = <Map<String, Object?>>[];
  final List<Map<String, Object?>> rewards = <Map<String, Object?>>[];
  final List<Map<String, Object?>> redemptions = <Map<String, Object?>>[];
  final List<Map<String, Object?>> ledger = <Map<String, Object?>>[];

  final List<Map<String, Object?>> avatars = <Map<String, Object?>>[];

  final List<Map<String, Object?>> standardTaskPlan = <Map<String, Object?>>[];

  final List<Map<String, Object?>> standardRewardPool =
      <Map<String, Object?>>[];

  final Map<String, List<Map<String, Object?>>> taskPlans =
      <String, List<Map<String, Object?>>>{};

  int _sequence = 0;

  String nextId(String prefix) {
    _sequence += 1;
    return '${prefix}_${_sequence.toString().padLeft(4, '0')}';
  }

  Map<String, Object?>? findWhere(
    List<Map<String, Object?>> collection,
    bool Function(Map<String, Object?> row) test,
  ) {
    for (final row in collection) {
      if (test(row)) return row;
    }
    return null;
  }

  Map<String, Object?>? findById(
    List<Map<String, Object?>> collection,
    String id,
  ) {
    for (final row in collection) {
      if (row['id'] == id) return row;
    }
    return null;
  }

  int balanceOf(String childId) => ledger
      .where((Map<String, Object?> e) => e['childId'] == childId)
      .fold(
        0,
        (int sum, Map<String, Object?> e) => sum + (e['amount']! as int),
      );

  void reset() {
    parents.clear();
    children.clear();
    tasks.clear();
    rewards.clear();
    redemptions.clear();
    ledger.clear();
    avatars.clear();
    standardTaskPlan.clear();
    standardRewardPool.clear();
    taskPlans.clear();
    _sequence = 0;
  }

  Set<String> childIdsOf(String parentId) => children
      .where((Map<String, Object?> row) => row['parentId'] == parentId)
      .map((Map<String, Object?> row) => row['id']! as String)
      .toSet();

  void addLedger({
    required String childId,
    required int amount,
    required String reason,
    required String reference,
    required DateTime at,
  }) {
    ledger.add(<String, Object?>{
      'id': nextId('ledger'),
      'childId': childId,
      'amount': amount,
      'reason': reason,
      'occurredAt': at.toIso8601String(),
      'reference': reference,
    });
  }

  String issueLinkCode() {
    final suffix = nextId('code').split('_').last.padLeft(3, '0');
    return 'LGS${suffix.substring(suffix.length - 3)}';
  }

  static bool sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
