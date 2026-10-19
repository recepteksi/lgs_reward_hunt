/// What kind of thing a reward is.
///
/// Five, the design's: time on a [screen], something [fun] to go and do, a
/// [treat] to eat, time with friends — [social] — and [free] for anything else,
/// which is also the [fallback] for a row the app cannot place. The shop
/// filters by these and each has its own glyph; neither the words nor the
/// glyphs are the domain's business.
enum RewardCategoryEnum {
  screen,
  fun,
  treat,
  social,
  free;

  static const RewardCategoryEnum fallback = RewardCategoryEnum.free;

  static RewardCategoryEnum fromName(String? name) =>
      RewardCategoryEnum.values.firstWhere(
        (RewardCategoryEnum category) => category.name == name,
        orElse: () => fallback,
      );
}
