/// The three grounds an icon button can sit on.
///
/// [tonal] is the affirmative one and carries the primary container; [neutral]
/// is the quiet grey for icons that only move you somewhere; [plain] has no
/// ground at all, for a bar that is already a surface.
///
/// A caller picks a named constructor on `AppIconButton` rather than passing
/// one of these, which is what keeps the list closed.
enum AppIconButtonToneEnum { tonal, neutral, plain }
