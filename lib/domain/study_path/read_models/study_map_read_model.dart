import 'package:lgs_reward_hunt/core/base/base_read_model.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/domain/study_path/read_models/study_path_read_model.dart';

/// Everything the home map draws, read in one go: whose map it is, their
/// face, their balance, and the road.
///
/// [avatar] is null for a child without a face in the catalogue. [balance] is
/// what the child may spend right now.
final class StudyMapReadModel extends BaseReadModel {
  const StudyMapReadModel({
    required this.child,
    required this.avatar,
    required this.balance,
    required this.path,
  });

  final ChildEntity child;

  final AvatarEntity? avatar;

  final int balance;

  final StudyPathReadModel path;

  @override
  List<Object?> get props => <Object?>[child, avatar, balance, path];
}
