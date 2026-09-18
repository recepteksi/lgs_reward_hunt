import 'package:either_dart/either.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_response.dart';

part 'child_response_dto.g.dart';

/// A child, as the server sends one.
///
/// [avatarId] is absent for a child who joined with a link code and has not
/// picked a face.
///
/// [toEntity] turns it into a [ChildEntity]: a child arrives from three
/// endpoints — created, linked, or read back — and one mapper is one answer
/// about what a child is.
@JsonSerializable()
final class ChildResponseDto extends BaseResponse {
  const ChildResponseDto({
    required this.id,
    required this.parentId,
    required this.name,
    required this.gradeLevel,
    this.avatarId,
  });

  factory ChildResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ChildResponseDtoFromJson(json);

  final String id;

  final String parentId;

  final String name;

  final int gradeLevel;

  final String? avatarId;

  @override
  Map<String, dynamic> toJson() => _$ChildResponseDtoToJson(this);

  Either<Failure, ChildEntity> toEntity() => ChildEntity.create(
    id: id,
    parentId: parentId,
    name: name,
    gradeLevel: gradeLevel,
    avatarId: avatarId,
  );
}
