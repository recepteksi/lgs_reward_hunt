/// The environments this app is built for.
///
/// The value itself, and nothing derived from it: which backend a flavor talks
/// to and what it is called live in `AppConfig`, so a `switch` on this enum
/// exists in exactly one place.
enum FlavorEnum { dev, prod }
