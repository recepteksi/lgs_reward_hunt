import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'payload_envelope_dto.g.dart';

/// The shape an encrypted body travels in.
///
/// [payload] is the ciphertext and its authentication tag, base64; [iv] is the
/// fresh initialisation vector that ciphertext was produced with, base64 as
/// well. It is the same envelope the backend will speak, which is why the type
/// exists before the encryption does: the wire format is a contract, and
/// agreeing on it late is how two sides end up with two formats.
///
/// A body is not encrypted today — see `PassthroughPayloadCodec` — and this
/// type is what the codec will produce the day it is.
@JsonSerializable()
final class PayloadEnvelopeDto extends BaseRequest {
  const PayloadEnvelopeDto({required this.payload, required this.iv});

  factory PayloadEnvelopeDto.fromJson(Map<String, dynamic> json) =>
      _$PayloadEnvelopeDtoFromJson(json);

  final String payload;

  final String iv;

  @override
  Map<String, dynamic> toJson() => _$PayloadEnvelopeDtoToJson(this);
}
