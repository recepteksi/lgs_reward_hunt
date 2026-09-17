import 'package:lgs_reward_hunt/core/base/base_read_model.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/household_read_model.dart';

/// What the "who uses this device" step shows: each child with their balance,
/// and which one the device opens on now.
///
/// A value object, a snapshot put together for one page. [balances] is keyed
/// by child id and [balanceOf] reads it, answering zero for a child with no
/// ledger yet. [isActive] is whether a child is the device's current one.
/// [needsChoice] is the step's own rule: with a single child there is nothing
/// to choose, and the step chooses for the parent.
final class DeviceChoiceReadModel extends BaseReadModel {
  const DeviceChoiceReadModel({
    required this.household,
    required this.balances,
    required this.activeChildId,
  });

  final HouseholdReadModel household;

  final Map<String, int> balances;

  final String? activeChildId;

  bool get needsChoice => household.children.length > ValueConstants.one;

  int balanceOf(ChildEntity child) => balances[child.id] ?? ValueConstants.zero;

  bool isActive(ChildEntity child) => child.id == activeChildId;

  @override
  List<Object?> get props => <Object?>[household, balances, activeChildId];
}
