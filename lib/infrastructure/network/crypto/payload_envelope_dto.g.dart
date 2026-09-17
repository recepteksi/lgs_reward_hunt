// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payload_envelope_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayloadEnvelopeDto _$PayloadEnvelopeDtoFromJson(Map<String, dynamic> json) =>
    PayloadEnvelopeDto(
      payload: json['payload'] as String,
      iv: json['iv'] as String,
    );

Map<String, dynamic> _$PayloadEnvelopeDtoToJson(PayloadEnvelopeDto instance) =>
    <String, dynamic>{'payload': instance.payload, 'iv': instance.iv};
