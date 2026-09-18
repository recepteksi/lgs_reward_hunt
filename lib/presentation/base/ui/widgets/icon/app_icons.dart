/// Every icon the app draws, as the design system drew it.
///
/// They are SVG markup rather than a font, and they are the design's own paths
/// rather than Material's nearest equivalent, because the shapes carry the
/// product's voice: the parent button is a shield, the rewards tab is a wrapped
/// present, progress is four rising bars. Material's set would say the same
/// things in a different accent.
///
/// Each constant is a complete `<svg>` whose paths are `currentColor`, so
/// `AppIcon` tints one by wrapping it rather than by string substitution — a
/// colour spliced into markup is a colour that cannot come from the theme.
///
/// [star] is the points currency and appears nowhere that is not about points.
/// [google] and [apple] are the two sign-in platforms' own marks, drawn in the
/// ink of the button they sit on.
///
/// [shield] is the parent's door: it is a guard, not a lock, because the parent
/// is the person who set the tasks rather than an obstacle to them.
///
/// [signOut] is a door with an arrow leaving it. It is only on the parent's
/// side, because signing out is the parent's action.
abstract final class AppIcons {
  static const String home =
      '<svg viewBox="0 0 24 24"><path d="M11.3 3.2a1.1 1.1 0 0 1 1.4 0l7.6 6.2c.3.2.4.5.4.8V20a1.6 1.6 0 0 1-1.6 1.6h-4.4v-6.2H9.3v6.2H4.9A1.6 1.6 0 0 1 3.3 20v-9.8c0-.3.1-.6.4-.8z" fill="currentColor"/></svg>';

  static const String rewards =
      '<svg viewBox="0 0 24 24"><path d="M3.4 11.8h7.3v9.8H5.1a1.7 1.7 0 0 1-1.7-1.7zM13.3 11.8h7.3v8.1a1.7 1.7 0 0 1-1.7 1.7h-5.6zM2.6 6.7h8.1v3.5H2.6zM13.3 6.7h8.1v3.5h-8.1zM8.6 2.4c1.7 0 2.7 1.9 3.1 4.3H8.6a2.15 2.15 0 0 1 0-4.3zM15.4 2.4a2.15 2.15 0 0 1 0 4.3h-3.1c.4-2.4 1.4-4.3 3.1-4.3z" fill="currentColor"/></svg>';

  static const String progress =
      '<svg viewBox="0 0 24 24"><path d="M3.5 12.8h3.2v8.4H3.5zM9 7.2h3.2v14H9zM14.5 15.4h3.2v5.8h-3.2zM20 3.4h3.2v17.8H20z" fill="currentColor"/></svg>';

  static const String profile =
      '<svg viewBox="0 0 24 24"><path d="M12 12.4a4.1 4.1 0 1 0 0-8.2 4.1 4.1 0 0 0 0 8.2zM4.4 20.8c0-3.7 3.4-6 7.6-6s7.6 2.3 7.6 6a.9.9 0 0 1-.9.9H5.3a.9.9 0 0 1-.9-.9z" fill="currentColor"/></svg>';

  static const String star =
      '<svg viewBox="0 0 24 24"><path d="M12 2.6l2.86 5.9 6.44.9-4.68 4.55 1.12 6.42L12 17.3l-5.74 3.07 1.12-6.42L2.7 9.4l6.44-.9z" fill="currentColor"/></svg>';

  static const String shield =
      '<svg viewBox="0 0 24 24"><path d="M11.6 2.5a1.1 1.1 0 0 1 .8 0l6.7 2.6c.4.1.6.5.6.9v5.6c0 4.9-3.4 8.4-7.7 9.7-4.3-1.3-7.7-4.8-7.7-9.7V6c0-.4.2-.8.6-.9z" fill="currentColor"/></svg>';

  static const String flame =
      '<svg viewBox="0 0 24 24"><path d="M12.6 2.4c.4 3-1.4 4.2-2.7 5.6-1.5 1.6-2.6 3-2.6 5.4A6.7 6.7 0 0 0 14 21.4c3.4-.7 5.6-3.6 5.6-7 0-4.4-3.4-6.2-4.4-9.2-.3 1.6-1.2 2.5-2.1 3 .2-2-.2-4.6-.5-5.8z" fill="currentColor"/></svg>';

  static const String check =
      '<svg viewBox="0 0 24 24"><path d="M4 12.6l5 5L20 6.4" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"/></svg>';

  static const String plus =
      '<svg viewBox="0 0 24 24"><path d="M12 4.6v14.8M4.6 12h14.8" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"/></svg>';

  static const String forward =
      '<svg viewBox="0 0 24 24"><path d="M9.5 5.5l6.5 6.5-6.5 6.5" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/></svg>';

  static const String back =
      '<svg viewBox="0 0 20 20"><path d="M12.2 4.4L6.4 10l5.8 5.6" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/></svg>';

  static const String close =
      '<svg viewBox="0 0 16 16"><path d="M3.6 3.6l8.8 8.8M12.4 3.6l-8.8 8.8" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>';

  static const String google =
      '<svg viewBox="0 0 24 24"><path d="M21.6 12.2c0-.7-.1-1.4-.2-2H12v3.8h5.4a4.6 4.6 0 0 1-2 3v2.5h3.2c1.9-1.7 3-4.3 3-7.3zM12 22c2.7 0 5-.9 6.6-2.4l-3.2-2.5c-.9.6-2 1-3.4 1-2.6 0-4.8-1.8-5.6-4.1H3.1v2.6A10 10 0 0 0 12 22zM6.4 14a6 6 0 0 1 0-4V7.4H3.1a10 10 0 0 0 0 9zM12 5.9c1.5 0 2.8.5 3.8 1.5l2.9-2.9A10 10 0 0 0 3.1 7.4L6.4 10c.8-2.3 3-4.1 5.6-4.1z" fill="currentColor"/></svg>';

  static const String apple =
      '<svg viewBox="0 0 20 20"><path d="M13.2 2.6c.1 1-.3 2-.9 2.7-.7.8-1.7 1.3-2.6 1.2-.1-1 .3-2 .9-2.8.7-.8 1.8-1.2 2.6-1.1zM16.6 13.6c-.5 1.2-.8 1.8-1.5 2.8-1 1.4-2.3 1.5-3.1 1.5-.9 0-1.5-.5-2.6-.5-1.1 0-1.7.5-2.6.5-.8 0-2-.6-3-2-2-3-2.2-7.4.9-9.1.9-.5 1.9-.6 2.8-.6 1 0 1.6.5 2.4.5.8 0 1.3-.5 2.5-.5 1 0 1.9.4 2.6 1.2-2.3 1.4-2 4.7.2 5.7z" fill="currentColor"/></svg>';

  static const String retry =
      '<svg viewBox="0 0 24 24"><path d="M19.4 12a7.4 7.4 0 1 1-2.2-5.2M18.6 3.4v3.8h-3.8" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/></svg>';

  static const String locked =
      '<svg viewBox="0 0 18 18"><rect x="3" y="8" width="12" height="8" rx="2" fill="currentColor"/><path d="M6 8V6a3 3 0 0 1 6 0v2" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>';

  static const String signOut =
      '<svg viewBox="0 0 24 24"><path d="M9.6 4.2H6a1.8 1.8 0 0 0-1.8 1.8v12A1.8 1.8 0 0 0 6 19.8h3.6M15.4 16.4 19.8 12l-4.4-4.4M19.6 12H9.4" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/></svg>';

  static const String clock =
      '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" stroke-width="1.9"/><path d="M12 6.8v5.5l3.4 2" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round"/></svg>';

  static const String alert =
      '<svg viewBox="0 0 24 24"><path d="M12 3.4l9 15.6H3z" fill="none" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/><path d="M12 9.4v4.2M12 16.2v.1" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"/></svg>';

  static const String empty =
      '<svg viewBox="0 0 24 24"><path d="M3.4 8.6h17.2v10.2a1.4 1.4 0 0 1-1.4 1.4H4.8a1.4 1.4 0 0 1-1.4-1.4zM2.6 4.4h18.8v3.4H2.6z" fill="currentColor"/></svg>';

  static const String categoryScreen =
      '<svg viewBox="0 0 24 24"><path d="M3.4 4.6h17.2a1.4 1.4 0 0 1 1.4 1.4v9.6a1.4 1.4 0 0 1-1.4 1.4H3.4A1.4 1.4 0 0 1 2 15.6V6a1.4 1.4 0 0 1 1.4-1.4zM8.8 19h6.4a.9.9 0 0 1 0 1.8H8.8a.9.9 0 0 1 0-1.8z" fill="currentColor"/></svg>';

  static const String categoryFun =
      '<svg viewBox="0 0 24 24"><path d="M3.2 7.4A1.8 1.8 0 0 1 5 5.6h14a1.8 1.8 0 0 1 1.8 1.8v1.9a2.7 2.7 0 0 0 0 5.4v1.9A1.8 1.8 0 0 1 19 18.4H5a1.8 1.8 0 0 1-1.8-1.8v-1.9a2.7 2.7 0 0 0 0-5.4z" fill="currentColor"/></svg>';

  static const String categoryTreat =
      '<svg viewBox="0 0 24 24"><path d="M12 2.4a6.2 6.2 0 0 1 6.2 6.2H5.8A6.2 6.2 0 0 1 12 2.4zM6.3 10.2h11.4L12 21.6z" fill="currentColor"/></svg>';

  static const String categorySocial =
      '<svg viewBox="0 0 24 24"><path d="M9.2 3.6a3.4 3.4 0 1 1 0 6.8 3.4 3.4 0 0 1 0-6.8zm0 8.3c3.7 0 6.7 1.8 6.7 4.1v2.4H2.5v-2.4c0-2.3 3-4.1 6.7-4.1zm8.4-7.1a2.9 2.9 0 1 1 0 5.8 2.9 2.9 0 0 1 0-5.8zm.3 7.3c2.4.3 3.8 1.7 3.8 3.5v2.8h-3.6v-2.4c0-1.4-.5-2.7-1.5-3.6z" fill="currentColor"/></svg>';

  static const String categoryFree = star;

  static const String categoryOther =
      '<svg viewBox="0 0 24 24"><path d="M2.6 10.4h18.8v9.4a1.2 1.2 0 0 1-1.2 1.2H3.8a1.2 1.2 0 0 1-1.2-1.2zM2 5.6h20v3.6H2zM10.8 5.6h2.4v15.4h-2.4zM7.6 2.2c1.7 0 3.1 1.3 3.6 3.4H8.4a1.7 1.7 0 0 1 0-3.4zm8.8 0a1.7 1.7 0 0 1 0 3.4h-2.8c.5-2.1 1.9-3.4 2.8-3.4z" fill="currentColor"/></svg>';
}
