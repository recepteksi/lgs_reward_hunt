/// Type sizes, by role.
///
/// A size is chosen by what the text IS, not by how big it should look — that
/// is what keeps two screens agreeing about what a title is. Sizes only:
/// weight, tracking and colour come from the `TextTheme` the app builds from
/// these, where the design's heavy weights live (900 for anything structural,
/// 800 for prose, 700 for the quiet lines under it).
///
/// [display] is the balance on its own screen and the day number on the map;
/// [balance] is the same figure worn as a pill in a bar, and [cost] the price
/// on a reward's card — three sizes for one number, because a figure that is
/// the subject of a screen and a figure tucked into a bar are not the same
/// thing said louder. [heading] titles a screen, [title] a card. [button] is every control's
/// label, [body] every sentence. [badge] is the figure inside a pill, [meta]
/// the line under a task's name, [caption] the smallest thing still meant to be
/// read, and [label] the tracked capitals over a section — the one size that is
/// never a sentence.
abstract final class AppTypography {
  static const double display = 44;

  static const double balance = 20;

  static const double cost = 17;

  static const double heading = 26;

  static const double title = 16;

  static const double button = 15;

  static const double body = 14;

  static const double badge = 13;

  static const double meta = 12;

  static const double caption = 11;

  static const double label = 10;

  static const double labelTracking = 1.2;
}
