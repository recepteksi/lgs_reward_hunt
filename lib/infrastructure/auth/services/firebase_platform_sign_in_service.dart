import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/auth/enums/auth_provider_enum.dart';
import 'package:lgs_reward_hunt/domain/auth/interfaces/platform_sign_in_interface.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/platform_identity_value_object.dart';
import 'package:lgs_reward_hunt/infrastructure/config/app_config.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Google and Apple sign-in, through Firebase Authentication.
///
/// The platform's own sheet proves who the parent is; that proof becomes a
/// Firebase credential, and the Firebase ID token is what the app's backend is
/// handed to verify. Firebase is reached lazily, inside [signIn], so nothing
/// touches it until a parent taps a button — a test that builds the container
/// never needs Firebase initialised.
///
/// Google: `GoogleSignIn` is initialised once with the flavor's
/// `AppConfig.googleServerClientId` — the web OAuth client Android's
/// Credential Manager needs to issue an ID token. Apple: a random nonce is
/// sent hashed to Apple and raw to Firebase, which is how Firebase knows the
/// Apple token was issued for this sign-in and not replayed.
///
/// A sheet the parent closes answers `FailureMessageKey.signInCancelled`; any
/// other refusal `FailureMessageKey.platformSignInFailed`.
@LazySingleton(as: PlatformSignInInterface)
final class FirebasePlatformSignInService implements PlatformSignInInterface {
  FirebasePlatformSignInService();

  static const int _nonceLength = 32;

  static const String _nonceCharset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

  static const String _appleProviderId = 'apple.com';

  bool _googleReady = false;

  @override
  Future<Either<Failure, PlatformIdentityValueObject>> signIn(
    AuthProviderEnum provider,
  ) async {
    try {
      final (
        UserCredential credential,
        String fallbackName,
        String fallbackEmail,
      ) = switch (provider) {
        AuthProviderEnum.google => await _google(),
        AuthProviderEnum.apple => await _apple(),
      };
      final User? user = credential.user;
      final String? token = await user?.getIdToken();
      if (user == null || token == null) {
        return const Left(
          UnknownFailure(FailureMessageKey.platformSignInFailed),
        );
      }

      return Right(
        PlatformIdentityValueObject(
          provider: provider,
          idToken: token,
          email: user.email ?? fallbackEmail,
          displayName: user.displayName ?? fallbackName,
        ),
      );
    } on GoogleSignInException catch (error) {
      return Left(
        error.code == GoogleSignInExceptionCode.canceled
            ? const ValidationFailure(FailureMessageKey.signInCancelled)
            : const UnknownFailure(FailureMessageKey.platformSignInFailed),
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      return Left(
        error.code == AuthorizationErrorCode.canceled
            ? const ValidationFailure(FailureMessageKey.signInCancelled)
            : const UnknownFailure(FailureMessageKey.platformSignInFailed),
      );
    } catch (_) {
      return const Left(UnknownFailure(FailureMessageKey.platformSignInFailed));
    }
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (_googleReady) await GoogleSignIn.instance.signOut();
  }

  Future<(UserCredential, String, String)> _google() async {
    if (!_googleReady) {
      await GoogleSignIn.instance.initialize(
        serverClientId: AppConfig.googleServerClientId,
      );
      _googleReady = true;
    }
    final GoogleSignInAccount account = await GoogleSignIn.instance
        .authenticate();
    final UserCredential credential = await FirebaseAuth.instance
        .signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: account.authentication.idToken,
          ),
        );
    return (
      credential,
      account.displayName ?? CharConstants.empty,
      account.email,
    );
  }

  Future<(UserCredential, String, String)> _apple() async {
    final String rawNonce = _nonce();
    final AuthorizationCredentialAppleID apple =
        await SignInWithApple.getAppleIDCredential(
          scopes: <AppleIDAuthorizationScopes>[
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: sha256.convert(utf8.encode(rawNonce)).toString(),
        );
    final UserCredential credential = await FirebaseAuth.instance
        .signInWithCredential(
          OAuthProvider(_appleProviderId)
              .credential(idToken: apple.identityToken, rawNonce: rawNonce),
        );
    final String name = <String?>[
      apple.givenName,
      apple.familyName,
    ].whereType<String>().join(CharConstants.space);
    return (credential, name, apple.email ?? CharConstants.empty);
  }

  String _nonce() {
    final Random random = Random.secure();
    return List<String>.generate(
      _nonceLength,
      (_) => _nonceCharset[random.nextInt(_nonceCharset.length)],
    ).join();
  }
}
