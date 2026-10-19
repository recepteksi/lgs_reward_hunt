/// Fixed measurements that are not spacing and not a radius.
///
/// A control has a height because a thumb has a size, not because a designer
/// liked the number — so these do not belong on the spacing ladder, where they
/// would be read as "two steps up" and adjusted like one.
///
/// [minTapTarget] is the floor for anything a finger is meant to hit; a badge
/// may be smaller because it is not a button. [buttonHeight] is what a button
/// actually gets, comfortably above that floor, and [iconButton] is the square
/// version of the same rule.
///
/// [edgeDepth], [edgePressed] and [pressTravel] are the design's signature:
/// a button sits on a solid unblurred edge below it, and pressing it moves the
/// face down onto that edge instead of dimming it. The three numbers have to
/// agree — the travel is the depth minus what is left showing — which is
/// exactly why they are named here rather than typed into each button.
///
/// [fab] is the parent button in the middle of the navigation bar, [taskCheck]
/// the circle at the head of a task row, [dayCell] one day in the week strip,
/// [progressRing] the day ring, and [levelTile] the square holding a level
/// number. [border], [borderStrong] and [borderThick] are the three line
/// weights the design uses and the only three it uses. [unitScale] is a
/// widget at its own size, the resting value of anything that grows when
/// chosen.
abstract final class AppSizes {
  static const double minTapTarget = 44;

  static const double buttonHeight = 48;

  static const double iconButton = 44;

  static const double fab = 56;

  static const double fabBorder = 5;

  static const double edgeDepth = 5;

  static const double edgeDepthDisabled = 4;

  static const double buttonPadding = 22;

  static const double textButtonPadding = 12;

  static const double glowOffset = 10;

  static const double glowBlur = 20;

  static const double edgePressed = 1;

  static const double pressTravel = 4;

  static const double taskCheck = 30;

  static const double dayCell = 56;

  static const double progressRing = 54;

  static const double progressRingStroke = 7;

  static const double levelTile = 64;

  static const double progressBar = 5;

  static const double statusPill = 28;

  static const double pointsPill = 30;

  static const double streakPill = 34;

  static const double pointsPillLarge = 42;

  static const double chip = 36;

  static const double border = 1;

  static const double borderStrong = 1.5;

  static const double borderThick = 2;

  static const double checkBorder = 2.5;

  static const double iconSizeSmall = 14;

  static const double iconSizeMedium = 17;

  static const double iconSize = 20;

  static const double iconSizeLarge = 22;

  static const double statusDot = 22;

  static const double iconTile = 46;

  static const double avatarTile = 38;

  static const double unitScale = 1;
}
