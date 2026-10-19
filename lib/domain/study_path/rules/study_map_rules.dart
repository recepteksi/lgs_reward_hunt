/// How much of the road to the exam the map shows.
///
/// [stopsBeforeToday] is the two finished days the path starts with, so a
/// student opens the map on progress rather than on an empty start line.
/// [visibleStops] is how many days the path draws in all — the rest of the way
/// to the exam is a dashed line and a count, because three hundred stops is a
/// scroll nobody finishes. [stopsPerZone] groups the stops into the named
/// stretches the map divides itself into.
abstract final class StudyMapRules {
  static const int stopsBeforeToday = 2;

  static const int visibleStops = 44;

  static const int stopsPerZone = 6;
}
