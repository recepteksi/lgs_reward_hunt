/// The app's one type face.
///
/// Nunito, and nothing beside it. The product has to read as friendly to a
/// thirteen-year-old without reading as childish to the parent looking over
/// their shoulder, and a single rounded grotesque carrying three heavy weights
/// does that better than a display face paired with a text face — a pairing
/// puts a seam down the middle of a screen that is mostly numbers and short
/// labels. It also carries the full Turkish diacritics, dotless `ı` and dotted
/// `İ` included, which is the test most software faces fail.
///
/// [family] is bundled as one variable file, so 700, 800 and 900 are axis
/// positions rather than three assets, and none of them is fetched at runtime.
abstract final class AppFonts {
  static const String family = 'Nunito';
}
