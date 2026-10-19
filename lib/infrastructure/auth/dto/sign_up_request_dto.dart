import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'sign_up_request_dto.g.dart';

/// What is sent to create a parent's account.
///
/// The three fields are already validated — the name is trimmed and the email
/// and password came out of a `CredentialsValueObject` — so this type carries them
/// and nothing else. Its job is to make the request typed: a map literal spells
/// its keys, and a spelling mistake in one is a 422 nobody can explain.
@JsonSerializable(createFactory: false)
final class SignUpRequestDto extends BaseRequest {
  const SignUpRequestDto({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;

  final String email;

  final String password;

  @override
  Map<String, dynamic> toJson() => _$SignUpRequestDtoToJson(this);
}
