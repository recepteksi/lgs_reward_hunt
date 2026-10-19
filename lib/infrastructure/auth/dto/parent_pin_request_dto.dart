import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'parent_pin_request_dto.g.dart';

/// What is sent to set the parent's PIN, and to check one.
///
/// One type for both, because they carry the same thing and differ only in what
/// the server does with it — two identical DTOs would drift the first time one
/// of them gained a field.
@JsonSerializable(createFactory: false)
final class ParentPinRequestDto extends BaseRequest {
  const ParentPinRequestDto({required this.pin});

  final String pin;

  @override
  Map<String, dynamic> toJson() => _$ParentPinRequestDtoToJson(this);
}
