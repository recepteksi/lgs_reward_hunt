import 'package:either_dart/either.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_response.dart';

part 'parent_response_dto.g.dart';

/// A parent, as the server sends one.
///
/// It is the answer to four different requests — signing up, signing in,
/// setting the PIN, creating an account through the link flow — which is
/// exactly why it is one type: those four cannot disagree about what a parent
/// looks like.
///
/// [email] is nullable because the link flow creates a parent before there is
/// one; `toEntity` turns that into the empty string the entity expects rather
/// than leaving a null to travel further.
///
/// [toEntity] turns it into a [ParentEntity] — one mapper for every door a
/// parent comes through, `AccountRepository` and `AuthRepository` alike, so
/// the two cannot disagree about what a parent is.
@JsonSerializable()
final class ParentResponseDto extends BaseResponse {
  const ParentResponseDto({
    required this.id,
    required this.name,
    required this.linkCode,
    this.email,
  });

  factory ParentResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ParentResponseDtoFromJson(json);

  final String id;

  final String name;

  final String linkCode;

  final String? email;

  @override
  Map<String, dynamic> toJson() => _$ParentResponseDtoToJson(this);

  Either<Failure, ParentEntity> toEntity() => ParentEntity.create(
    id: id,
    name: name,
    email: email ?? CharConstants.empty,
    linkCode: linkCode,
  );
}
