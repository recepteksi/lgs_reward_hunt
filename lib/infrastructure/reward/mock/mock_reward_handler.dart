import 'package:lgs_reward_hunt/core/constants/char_constants.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/domain/points/enums/points_reason_enum.dart';
import 'package:lgs_reward_hunt/domain/points/rules/points_rules.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/redemption_status_enum.dart';
import 'package:lgs_reward_hunt/domain/reward/enums/reward_category_enum.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_handler_interface.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_request.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_response.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_route.dart';
import 'package:lgs_reward_hunt/infrastructure/network/mock/mock_store.dart';

/// The reward shop: the standard pool, the parent's pool, asking for a reward,
/// and the parent's answer.
///
/// Asking for a reward **holds** the points immediately — the balance check
/// and the hold happen in the same step, so two requests cannot both pass a
/// check against the same points. Approving moves nothing, the hold already
/// did; only rejecting gives the points back.
///
/// Saving the pool makes the parent's active rewards exactly the pool sent: a
/// row with an id updates that reward, a row without one creates a reward,
/// and an active reward left out is retired — never deleted, because its
/// redemptions still point at it.
///
/// A parent can re-price a reward or switch it off, and remove it: a reward
/// nobody has asked for is deleted, one somebody has is kept for their history
/// and stops being listed.
final class MockRewardHandler implements MockHandlerInterface {
  const MockRewardHandler(this._store, this._clock);

  final MockStore _store;

  final DateTime Function() _clock;

  @override
  List<MockRoute> get routes => <MockRoute>[
    MockRoute(
      'GET',
      RegExp(r'^/reward-pools/standard$'),
      (_) => MockResponse.ok(_store.standardRewardPool),
    ),
    MockRoute('GET', RegExp(r'^/parents/([^/]+)/rewards$'), _rewardsOf),
    MockRoute('POST', RegExp(r'^/parents/([^/]+)/rewards$'), _createReward),
    MockRoute('PUT', RegExp(r'^/parents/([^/]+)/reward-pool$'), _savePool),
    MockRoute('PATCH', RegExp(r'^/rewards/([^/]+)$'), _updateReward),
    MockRoute('DELETE', RegExp(r'^/rewards/([^/]+)$'), _removeReward),
    MockRoute(
      'GET',
      RegExp(r'^/children/([^/]+)/redemptions$'),
      _redemptionsOf,
    ),
    MockRoute('POST', RegExp(r'^/children/([^/]+)/redemptions$'), _redeem),
    MockRoute('GET', RegExp(r'^/parents/([^/]+)/redemptions$'), _pendingFor),
    MockRoute(
      'POST',
      RegExp(r'^/redemptions/([^/]+)/approve$'),
      (MockRequest request) => _decide(request, approved: true),
    ),
    MockRoute(
      'POST',
      RegExp(r'^/redemptions/([^/]+)/reject$'),
      (MockRequest request) => _decide(request, approved: false),
    ),
  ];

  MockResponse _rewardsOf(MockRequest request) => MockResponse.ok(
    _store.rewards
        .where(
          (Map<String, Object?> row) =>
              row['parentId'] == request.id && row['isRemoved'] != true,
        )
        .toList(),
  );

  MockResponse _updateReward(MockRequest request) {
    final reward = _store.findById(_store.rewards, request.id);
    if (reward == null || reward['isRemoved'] == true) {
      return MockResponse.fail(404, FailureMessageKey.unexpectedResponse);
    }

    final cost = request.body['cost'] as int?;
    if (cost != null &&
        (cost < PointsRules.minRewardCost ||
            cost > PointsRules.maxRewardCost)) {
      return MockResponse.fail(422, FailureMessageKey.rewardCostInvalid);
    }
    if (cost != null) reward['cost'] = cost;

    final isActive = request.body['isActive'] as bool?;
    if (isActive != null) reward['isActive'] = isActive;
    return MockResponse.ok(reward);
  }

  MockResponse _removeReward(MockRequest request) {
    final reward = _store.findById(_store.rewards, request.id);
    if (reward == null) {
      return MockResponse.fail(404, FailureMessageKey.unexpectedResponse);
    }

    final asked = _store.redemptions.any(
      (Map<String, Object?> row) => row['rewardId'] == request.id,
    );
    if (asked) {
      reward
        ..['isActive'] = false
        ..['isRemoved'] = true;
    } else {
      _store.rewards.remove(reward);
    }
    return const MockResponse.noContent();
  }

  MockResponse _createReward(MockRequest request) {
    final refusal = _refusalOf(request.body);
    if (refusal != null) return refusal;

    final row = _newReward(request.id, request.body);
    _store.rewards.add(row);
    return MockResponse.created(row);
  }

  MockResponse _savePool(MockRequest request) {
    final parentId = request.id;
    if (_store.findById(_store.parents, parentId) == null) {
      return MockResponse.fail(404, FailureMessageKey.unauthorized);
    }

    final rows =
        (request.body['rewards'] as List<Object?>? ?? const <Object?>[])
            .map((Object? row) => Map<String, Object?>.from(row! as Map))
            .toList();
    if (rows.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.rewardPoolEmpty);
    }
    for (final row in rows) {
      final refusal = _refusalOf(row);
      if (refusal != null) return refusal;
    }

    final keptIds = <Object?>{};
    for (final row in rows) {
      final existing = row['id'] == null
          ? null
          : _store.findById(_store.rewards, row['id']! as String);
      if (existing == null || existing['parentId'] != parentId) {
        final created = _newReward(parentId, row);
        _store.rewards.add(created);
        keptIds.add(created['id']);
        continue;
      }
      existing
        ..['name'] = (row['name']! as String).trim()
        ..['category'] = RewardCategoryEnum.fromName(row['category'] as String?)
            .name
        ..['cost'] = row['cost']
        ..['isActive'] = true;
      keptIds.add(existing['id']);
    }

    for (final reward in _store.rewards) {
      if (reward['parentId'] == parentId && !keptIds.contains(reward['id'])) {
        reward['isActive'] = false;
      }
    }

    return MockResponse.ok(
      _store.rewards
          .where(
            (Map<String, Object?> row) =>
                row['parentId'] == parentId && row['isActive'] == true,
          )
          .toList(),
    );
  }

  MockResponse _redemptionsOf(MockRequest request) => MockResponse.ok(
    _store.redemptions
        .where((Map<String, Object?> row) => row['childId'] == request.id)
        .toList(),
  );

  MockResponse _redeem(MockRequest request) {
    final childId = request.id;
    if (_store.findById(_store.children, childId) == null) {
      return MockResponse.fail(404, FailureMessageKey.unauthorized);
    }

    final reward = _store.findById(
      _store.rewards,
      request.body['rewardId'] as String? ?? CharConstants.empty,
    );
    if (reward == null || reward['isActive'] != true) {
      return MockResponse.fail(404, FailureMessageKey.unexpectedResponse);
    }

    final cost = reward['cost']! as int;
    if (_store.balanceOf(childId) < cost) {
      return MockResponse.fail(409, FailureMessageKey.insufficientPoints);
    }

    final now = _clock();
    final row = <String, Object?>{
      'id': _store.nextId('redemption'),
      'childId': childId,
      'rewardId': reward['id'],
      'rewardName': reward['name'],
      'costAtRequest': cost,
      'status': RedemptionStatusEnum.pending.name,
      'requestedAt': now.toIso8601String(),
      'decidedAt': null,
      'parentNote': null,
    };
    _store.redemptions.add(row);

    _store.addLedger(
      childId: childId,
      amount: -cost,
      reason: PointsReasonEnum.redemptionHeld.name,
      reference: row['id']! as String,
      at: now,
    );

    return MockResponse.created(row);
  }

  MockResponse _pendingFor(MockRequest request) {
    final childIds = _store.childIdsOf(request.id);
    return MockResponse.ok(
      _store.redemptions
          .where(
            (Map<String, Object?> row) =>
                childIds.contains(row['childId']) &&
                row['status'] == RedemptionStatusEnum.pending.name,
          )
          .toList(),
    );
  }

  MockResponse _decide(MockRequest request, {required bool approved}) {
    final row = _store.findById(_store.redemptions, request.id);
    if (row == null) {
      return MockResponse.fail(404, FailureMessageKey.unexpectedResponse);
    }
    if (row['status'] != RedemptionStatusEnum.pending.name) {
      return MockResponse.fail(409, FailureMessageKey.redemptionNotPending);
    }

    final now = _clock();
    row['status'] =
        (approved
                ? RedemptionStatusEnum.approved
                : RedemptionStatusEnum.rejected)
            .name;
    row['decidedAt'] = now.toIso8601String();
    row['parentNote'] = approved ? null : request.body['note'] as String?;

    if (!approved) {
      _store.addLedger(
        childId: row['childId']! as String,
        amount: row['costAtRequest']! as int,
        reason: PointsReasonEnum.redemptionReleased.name,
        reference: request.id,
        at: now,
      );
    }

    return MockResponse.ok(row);
  }

  MockResponse? _refusalOf(Map<String, Object?> row) {
    final name = (row['name'] as String? ?? CharConstants.empty).trim();
    if (name.isEmpty) {
      return MockResponse.fail(422, FailureMessageKey.rewardNameEmpty);
    }

    final cost = row['cost'] as int? ?? 0;
    if (cost < PointsRules.minRewardCost || cost > PointsRules.maxRewardCost) {
      return MockResponse.fail(422, FailureMessageKey.rewardCostInvalid);
    }
    return null;
  }

  Map<String, Object?> _newReward(String parentId, Map<String, Object?> row) =>
      <String, Object?>{
        'id': _store.nextId('reward'),
        'parentId': parentId,
        'name': (row['name']! as String).trim(),
        'category': RewardCategoryEnum.fromName(row['category'] as String?)
            .name,
        'cost': row['cost'],
        'isActive': true,
      };
}
