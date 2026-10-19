import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/points/entities/points_account_entity.dart';
import 'package:lgs_reward_hunt/domain/points/entities/points_ledger_entry_entity.dart';
import 'package:lgs_reward_hunt/domain/points/interfaces/points_repository_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/network/api_paths.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart';
import 'package:lgs_reward_hunt/infrastructure/network/failure_from_dio.dart';
import 'package:lgs_reward_hunt/infrastructure/points/dto/points_account_response_dto.dart';
import 'package:lgs_reward_hunt/infrastructure/points/dto/points_entry_response_dto.dart';

/// Reading the ledger, over HTTP.
///
/// The server sends entries and the balance is computed from them here, by
/// [PointsAccountEntity]. Asking the server for a number the client can add up
/// itself is how the two end up disagreeing — and when they do, the user
/// believes the one on screen.
///
/// An entry whose reason this build does not recognise fails the call rather
/// than being dropped. A ledger silently missing rows still sums to something,
/// and that something is a wrong balance nobody can trace.
@LazySingleton(as: PointsRepositoryInterface)
final class PointsRepository implements PointsRepositoryInterface {
  const PointsRepository(this._client);

  final DioClient _client;

  @override
  Future<Either<Failure, PointsAccountEntity>> accountFor(
    String childId,
  ) async {
    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        ApiPaths.pointsOfChild(childId),
      );
      final account = PointsAccountResponseDto.fromJson(response.data!);

      final entries = <PointsLedgerEntryEntity>[];
      for (final PointsEntryResponseDto row in account.entries) {
        final parsed = row.toEntity();
        if (parsed.isLeft) return Left(parsed.left);
        entries.add(parsed.right);
      }
      entries.sort(
        (PointsLedgerEntryEntity a, PointsLedgerEntryEntity b) =>
            b.occurredAt.compareTo(a.occurredAt),
      );

      return Right(PointsAccountEntity(childId: childId, entries: entries));
    } catch (error) {
      return Left(failureFromDio(error));
    }
  }
}
