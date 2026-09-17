import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'sign_in_request_dto.g.dart';

/// What is sent to get back into an existing account.
@JsonSerializable(createFactory: false)
final class SignInRequestDto extends BaseRequest {
  const SignInRequestDto({required this.email, required this.password});

  final String email;

  final String password;

  @override
  Map<String, dynamic> toJson() => _$SignInRequestDtoToJson(this);
}
