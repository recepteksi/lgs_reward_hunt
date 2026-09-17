/// Which half of the catalogue a face is filed under.
///
/// It is a filter on the setup screen and nothing more: a child is not given a
/// gender by the app, the parent only narrows eight faces down to four. An
/// unknown name falls back to [girl], the first tab, so a face the server files
/// under a word the app does not know still appears somewhere.
enum AvatarGenderEnum {
  girl,
  boy;

  static const AvatarGenderEnum fallback = AvatarGenderEnum.girl;

  static AvatarGenderEnum fromName(String? name) =>
      AvatarGenderEnum.values.firstWhere(
        (AvatarGenderEnum gender) => gender.name == name,
        orElse: () => fallback,
      );
}
