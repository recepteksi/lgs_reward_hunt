/// The hair — and one hat — a face can be drawn with.
///
/// The catalogue names a style and the app knows how to draw it, so a face the
/// server has never sent still renders: an unknown name falls back to
/// [AvatarStyleEnum.short] rather than leaving a bald head on the screen.
enum AvatarStyleEnum {
  long,
  pigtail,
  bun,
  curly,
  short,
  spiky,
  cap,
  wave;

  static const AvatarStyleEnum fallback = AvatarStyleEnum.short;

  static AvatarStyleEnum fromName(String? name) =>
      AvatarStyleEnum.values.firstWhere(
        (AvatarStyleEnum style) => style.name == name,
        orElse: () => fallback,
      );
}
