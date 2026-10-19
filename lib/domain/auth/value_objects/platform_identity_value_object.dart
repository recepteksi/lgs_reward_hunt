import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/domain/auth/enums/auth_provider_enum.dart';

/// Who a platform sign-in says the parent is.
///
/// [idToken] is the Firebase ID token the backend verifies; [email] and
/// [displayName] are what the platform shared, which a new account is opened
/// with. [displayName] may be empty — Apple shares a name only the first time.
/// Nothing here is checked on the device: the token is the proof, and the
/// backend is the one that can verify it, so [validators] is empty.
final class PlatformIdentityValueObject
    extends
        BaseValueObject<
          ({
            AuthProviderEnum provider,
            String idToken,
            String email,
            String displayName,
          })
        > {
  const PlatformIdentityValueObject({
    required AuthProviderEnum provider,
    required String idToken,
    required String email,
    required String displayName,
  }) : super((
         provider: provider,
         idToken: idToken,
         email: email,
         displayName: displayName,
       ));

  AuthProviderEnum get provider => value.provider;

  String get idToken => value.idToken;

  String get email => value.email;

  String get displayName => value.displayName;

  @override
  List<
    BaseValueValidator<
      ({
        AuthProviderEnum provider,
        String idToken,
        String email,
        String displayName,
      })
    >
  >
  get validators => const [];
}
