import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'platform_sign_in_request_dto.g.dart';

/// A platform's proof of who the parent is, sent to open or find the account.
///
/// [idToken] is the Firebase ID token the server verifies; [email] and [name]
/// are what the platform shared, used only when the account is new.
@JsonSerializable(createFactory: false)
final class PlatformSignInRequestDto extends BaseRequest {
  const PlatformSignInRequestDto({
    required this.provider,
    required this.idToken,
    required this.email,
    required this.name,
  });

  final String provider;

  final String idToken;

  final String email;

  final String name;

  @override
  Map<String, dynamic> toJson() => _$PlatformSignInRequestDtoToJson(this);
}
