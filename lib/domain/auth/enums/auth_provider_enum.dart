/// The platforms a parent can sign in with instead of an email and password.
///
/// [google] and [apple], through Firebase Authentication. The app's own
/// backend still owns the account — the platform only proves who the parent
/// is — so a parent who signs in with Google and one who signed up with the
/// same email are the same household.
enum AuthProviderEnum { google, apple }
