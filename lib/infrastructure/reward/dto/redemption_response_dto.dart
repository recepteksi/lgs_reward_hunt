import 'package:either_dart/either.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/redemption_status_enum.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_response.dart';

part 'redemption_response_dto.g.dart';

/// A redemption — asked for, and perhaps decided — as the server sends one.
///
/// [toEntity] turns this row into its entity.
@JsonSerializable()
final class RedemptionResponseDto extends BaseResponse {
  const RedemptionResponseDto({
    required this.id,
    required this.childId,
    required this.rewardId,
    required this.rewardName,
    required this.costAtRequest,
    required this.requestedAt,
    this.status,
    this.decidedAt,
    this.parentNote,
  });

  factory RedemptionResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RedemptionResponseDtoFromJson(json);

  final String id;

  final String childId;

  final String rewardId;

  final String rewardName;

  final int costAtRequest;

  final String requestedAt;

  final String? status;

  final String? decidedAt;

  final String? parentNote;

  @override
  Map<String, dynamic> toJson() => _$RedemptionResponseDtoToJson(this);

  Either<Failure, RedemptionEntity> toEntity() {
    final RedemptionStatusEnum? known = RedemptionStatusEnum.values
        .where((RedemptionStatusEnum s) => s.name == status)
        .firstOrNull;
    if (known == null) {
      return const Left(
        ValidationFailure(FailureMessageKey.unexpectedResponse),
      );
    }
    final String? decided = decidedAt;
    return Right(
      RedemptionEntity(
        id: id,
        childId: childId,
        rewardId: rewardId,
        rewardName: rewardName,
        costAtRequest: costAtRequest,
        status: known,
        requestedAt: DateTime.parse(requestedAt),
        decidedAt: decided == null ? null : DateTime.parse(decided),
        parentNote: parentNote,
      ),
    );
  }
}
