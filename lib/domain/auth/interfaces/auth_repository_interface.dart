import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/auth/read_models/platform_sign_in_result_read_model.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/credentials_value_object.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/parent_pin_value_object.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/platform_identity_value_object.dart';

/// How a parent gets an account and gets back into it.
///
/// Only a parent signs in. A child never sees this: they arrive through the
/// link code on a device the parent already set up, which is why there is no
/// child credential anywhere in the app and no password for a thirteen-year-old
/// to forget the week before the exam.
///
/// [signUp] and [signIn] both answer with the parent, so a screen has the same
/// thing in its hands whichever door it came through. [setPin] is part of
/// setup rather than a setting: the app has no parent side until there is one.
/// [verifyPin] answers `true` or `false` rather than failing, because a wrong
/// PIN is an ordinary event on that screen and not an error to report.
///
/// [signInWithPlatform] hands the backend a platform's proof of who the parent
/// is and gets the account back — opened if the email is new, the existing one
/// if it is not.
abstract interface class AuthRepositoryInterface {
  Future<Either<Failure, ParentEntity>> signUp({
    required String name,
    required CredentialsValueObject credentials,
  });

  Future<Either<Failure, ParentEntity>> signIn(
    CredentialsValueObject credentials,
  );

  Future<Either<Failure, PlatformSignInResultReadModel>> signInWithPlatform(
    PlatformIdentityValueObject identity,
  );

  Future<Either<Failure, ParentEntity>> setPin({
    required String parentId,
    required ParentPinValueObject pin,
  });

  Future<Either<Failure, bool>> verifyPin({
    required String parentId,
    required String pin,
  });
}
