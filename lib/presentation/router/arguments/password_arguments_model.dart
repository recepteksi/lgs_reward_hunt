/// What the sign-up page hands to the password page, over the password route.
///
/// A model rather than two loose strings on the route, because `extra` is
/// `Object?` and a pair of positional strings is exactly the thing that gets
/// swapped one day.
///
/// It lives beside the routes rather than in either page, because it is the
/// route's contract: `AuthPage` builds it, `AppRouter` casts `extra` back to
/// it, and `PasswordPage` reads it. It is not domain — nothing here is
/// validated yet; that happens as `CredentialsValueObject` when the account is
/// created — and it is not an application DTO, because no use case takes it.
/// It is presentation carrying typed input from one page to the next.
final class PasswordArgumentsModel {
  const PasswordArgumentsModel({required this.name, required this.email});

  final String name;

  final String email;
}
