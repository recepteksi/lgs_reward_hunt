import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/core/validators/valid_parts_validator.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/email_value_object.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/entered_password_value_object.dart';
import 'package:lgs_reward_hunt/domain/auth/value_objects/password_value_object.dart';

/// An email and a password that have already been checked.
///
/// Built from its parts, each a value object with its own rules: an
/// [EmailValueObject], and a [PasswordValueObject] when an account is made
/// ([create]) or an [EnteredPasswordValueObject] when one signs in
/// ([existing]). Both factories answer `Either`, so credentials in hand are
/// credentials whose parts held — the form may grey out its button on the same
/// rules, but the form is never the only thing enforcing them. The email part
/// is reported first.
///
/// [email] and [password] are the checked strings a request is built from;
/// [displayName] is the part of the email before the `@`.
final class CredentialsValueObject
    extends
        BaseValueObject<
          ({EmailValueObject email, BaseValueObject<String> password})
        > {
  const CredentialsValueObject._(super.value);

  static Either<Failure, CredentialsValueObject> create({
    required String email,
    required String password,
  }) => _checked(
    CredentialsValueObject._((
      email: EmailValueObject(email),
      password: PasswordValueObject(password),
    )),
  );

  static Either<Failure, CredentialsValueObject> existing({
    required String email,
    required String password,
  }) => _checked(
    CredentialsValueObject._((
      email: EmailValueObject(email),
      password: EnteredPasswordValueObject(password),
    )),
  );

  static Either<Failure, CredentialsValueObject> _checked(
    CredentialsValueObject credentials,
  ) => credentials.valueObject.map((_) => credentials);

  String get email => value.email.value;

  String get password => value.password.value;

  String get displayName => email.split(CharConstants.at).first;

  @override
  List<
    BaseValueValidator<
      ({EmailValueObject email, BaseValueObject<String> password})
    >
  >
  get validators =>
      <
        BaseValueValidator<
          ({EmailValueObject email, BaseValueObject<String> password})
        >
      >[
        ValidPartsValidator(
          (
            ({EmailValueObject email, BaseValueObject<String> password}) parts,
          ) => <BaseValueObject<Object?>>[parts.email, parts.password],
        ),
      ];
}
