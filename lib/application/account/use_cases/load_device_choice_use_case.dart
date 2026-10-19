import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_household_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/device_choice_read_model.dart';
import 'package:lgs_reward_hunt/domain/points/interfaces/points_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';

/// Reads what the device step needs: the household, each child's balance, and
/// which child the device opens on now.
///
/// The household comes from [LoadHouseholdUseCase] rather than being read
/// again here, so "whose household" has one answer. The balances are read one
/// child at a time — there are at most two — and the first failure wins.
@injectable
final class LoadDeviceChoiceUseCase {
  const LoadDeviceChoiceUseCase(
    this._loadHousehold,
    this._points,
    this._session,
  );

  final LoadHouseholdUseCase _loadHousehold;

  final PointsRepositoryInterface _points;

  final SessionRepositoryInterface _session;

  Future<Either<Failure, DeviceChoiceReadModel>> call() async {
    final household = await _loadHousehold();
    if (household.isLeft) return Left(household.left);

    final Map<String, int> balances = <String, int>{};
    for (final ChildEntity child in household.right.children) {
      final account = await _points.accountFor(child.id);
      if (account.isLeft) return Left(account.left);
      balances[child.id] = account.right.balance;
    }

    final session = await _session.read();
    if (session.isLeft) return Left(session.left);

    return Right(
      DeviceChoiceReadModel(
        household: household.right,
        balances: balances,
        activeChildId: session.right.activeChildId,
      ),
    );
  }
}
