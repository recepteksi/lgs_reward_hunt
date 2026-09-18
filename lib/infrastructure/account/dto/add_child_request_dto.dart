import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';

part 'add_child_request_dto.g.dart';

/// What is sent to add a child to a parent's household.
///
/// Built from a validated `ChildProfileValueObject`, so a request with a blank name,
/// a grade the app is not for or no face never leaves the device.
@JsonSerializable(createFactory: false)
final class AddChildRequestDto extends BaseRequest {
  const AddChildRequestDto({
    required this.name,
    required this.gradeLevel,
    required this.avatarId,
  });

  final String name;

  final int gradeLevel;

  final String avatarId;

  @override
  Map<String, dynamic> toJson() => _$AddChildRequestDtoToJson(this);
}
