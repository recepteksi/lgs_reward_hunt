import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/points/entities/points_account_entity.dart';

/// Reading a child's ledger.
///
/// Read-only on purpose. Nothing in the app writes a points entry directly —
/// entries are a consequence of completing a task or asking for a reward, and
/// a port that let a caller add points would be a way to earn them without
/// doing anything.
abstract interface class PointsRepositoryInterface {
  Future<Either<Failure, PointsAccountEntity>> accountFor(String childId);
}
