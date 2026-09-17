/// The name a level carries, in four steps.
///
/// [forLevel] maps a level to its rank: the first level is a [rookie], and each
/// level after it climbs one rank until [treasureHunter], which is where the
/// names stop and the number keeps going. The words are presentation's.
enum LevelRankEnum {
  rookie,
  tracker,
  mapMaster,
  treasureHunter;

  static LevelRankEnum forLevel(int level) {
    final int index = level - 1;
    if (index <= 0) return rookie;
    return index >= values.length ? treasureHunter : values[index];
  }
}
