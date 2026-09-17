import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_child_header_use_case.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/read_child_snapshot_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/get_reward_shop_use_case.dart';
import 'package:lgs_reward_hunt/application/reward/use_cases/request_reward_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_header_read_model.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_snapshot_read_model.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/reward_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/read_models/reward_shop_read_model.dart';

part 'rewards_state.dart';

/// The rewards tab: the shop, and asking for a reward from it.
///
/// [load] reads whose tab it is and then their shop. [request] asks for a
/// reward and reads the shop again — the request held points, so the balance,
/// every card's state and the history have all moved, and the server is what
/// knows by how much. A request that went through ends in [RewardsRequested],
/// which the page announces once; a refused one in [RewardsRequestFailed].
///
/// `load(quietly: true)` is the tab coming back into view: it shows no
/// loading page and keeps what is on screen if the reload fails, and does
/// nothing unless the page is settled on [RewardsReady].
@injectable
final class RewardsCubit extends Cubit<RewardsState> {
  RewardsCubit(
    this._loadHeader,
    this._loadShop,
    this._request,
    this._readSnapshot,
  ) : super(const RewardsLoading(ChildSnapshotReadModel.empty));

  final LoadChildHeaderUseCase _loadHeader;

  final GetRewardShopUseCase _loadShop;

  final RequestRewardUseCase _request;

  final ReadChildSnapshotUseCase _readSnapshot;

  Future<void> load({bool quietly = false}) async {
    if (quietly && state is! RewardsReady) return;
    if (!quietly) emit(RewardsLoading(_readSnapshot()));

    final header = await _loadHeader();
    if (isClosed) return;
    if (header.isLeft) {
      if (!quietly) emit(RewardsFailed(header.left));
      return;
    }

    final shop = await _loadShop(childId: header.right.child.id);
    if (isClosed) return;

    switch (shop) {
      case Left(:final value):
        if (!quietly) emit(RewardsFailed(value));
      case Right(:final value):
        emit(RewardsReady(header.right, value));
    }
  }

  Future<void> request(RewardEntity reward) async {
    final RewardsState current = state;
    if (current is! RewardsShowing || current is RewardsRequesting) return;

    emit(RewardsRequesting(current.header, current.shop, reward.id));

    final result = await _request(
      childId: current.header.child.id,
      rewardId: reward.id,
    );
    if (isClosed) return;
    if (result.isLeft) {
      emit(RewardsRequestFailed(current.header, current.shop, result.left));
      return;
    }

    final shop = await _loadShop(childId: current.header.child.id);
    if (isClosed) return;

    emit(switch (shop) {
      Left(:final value) => RewardsRequestFailed(
        current.header,
        current.shop,
        value,
      ),
      Right(:final value) => RewardsRequested(
        current.header,
        value,
        reward.name,
      ),
    });
  }
}
