import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/enums/auth_provider_enum.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/platform_identity_value_object.dart';

/// Signing in with a platform — the Google or Apple sheet the phone shows.
///
/// A port, because the platform is a device capability the domain does not
/// care how is reached: today it is Firebase Authentication. [signIn] shows
/// the provider's own sheet and answers who the parent is; a parent who closes
/// the sheet answers `FailureMessageKey.signInCancelled`, which a page treats
/// as nothing having happened. [signOut] forgets the platform session.
abstract interface class PlatformSignInInterface {
  Future<Either<Failure, PlatformIdentityValueObject>> signIn(
    AuthProviderEnum provider,
  );

  Future<void> signOut();
}
