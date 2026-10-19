import 'package:either_dart/either.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/points/entities/points_ledger_entry_entity.dart';
import 'package:lgs_reward_hunt/domain/points/enums/points_reason_enum.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_response.dart';

part 'points_entry_response_dto.g.dart';

/// One line of a child's points ledger, as the server sends it.
///
/// [toEntity] turns this row into its entity.
@JsonSerializable()
final class PointsEntryResponseDto extends BaseResponse {
  const PointsEntryResponseDto({
    required this.id,
    required this.childId,
    required this.amount,
    required this.occurredAt,
    this.reason,
    this.reference,
  });

  factory PointsEntryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PointsEntryResponseDtoFromJson(json);

  final String id;

  final String childId;

  final int amount;

  final String occurredAt;

  final String? reason;

  final String? reference;

  @override
  Map<String, dynamic> toJson() => _$PointsEntryResponseDtoToJson(this);

  Either<Failure, PointsLedgerEntryEntity> toEntity() {
    final PointsReasonEnum? known = PointsReasonEnum.values
        .where((PointsReasonEnum r) => r.name == reason)
        .firstOrNull;
    if (known == null) {
      return const Left(
        ValidationFailure(FailureMessageKey.unexpectedResponse),
      );
    }
    return PointsLedgerEntryEntity.create(
      id: id,
      childId: childId,
      amount: amount,
      reason: known,
      occurredAt: DateTime.parse(occurredAt),
      reference: reference,
    );
  }
}
