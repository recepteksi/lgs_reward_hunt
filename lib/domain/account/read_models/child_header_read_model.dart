import 'package:lgs_reward_hunt/core/base/base_read_model.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';

/// Whose app this is, as the bar at the top of every tab shows it: the child
/// and their face.
///
/// [avatar] is null for a child without a face in the catalogue.
final class ChildHeaderReadModel extends BaseReadModel {
  const ChildHeaderReadModel({required this.child, required this.avatar});

  final ChildEntity child;

  final AvatarEntity? avatar;

  @override
  List<Object?> get props => <Object?>[child, avatar];
}
