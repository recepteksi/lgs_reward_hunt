/// Which of the seven shapes a button is wearing.
///
/// A caller never passes one of these: it picks a named constructor on
/// `AppButton`, and the enum is what keeps that list closed. Six are the design
/// system's; the seventh, [errorOutlined], exists for the retry inside a
/// failure card, whose ground is already the error container.
enum AppButtonVariantEnum {
  filled,
  reward,
  tonal,
  rewardTonal,
  outlined,
  errorOutlined,
  text,
}
