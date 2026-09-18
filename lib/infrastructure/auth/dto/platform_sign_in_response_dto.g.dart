// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_sign_in_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlatformSignInResponseDto _$PlatformSignInResponseDtoFromJson(
  Map<String, dynamic> json,
) => PlatformSignInResponseDto(
  parent: ParentResponseDto.fromJson(json['parent'] as Map<String, dynamic>),
  isNewAccount: json['isNewAccount'] as bool,
);

Map<String, dynamic> _$PlatformSignInResponseDtoToJson(
  PlatformSignInResponseDto instance,
) => <String, dynamic>{
  'parent': instance.parent.toJson(),
  'isNewAccount': instance.isNewAccount,
};
