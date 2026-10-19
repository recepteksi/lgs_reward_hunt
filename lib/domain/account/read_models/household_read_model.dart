import 'package:lgs_reward_hunt/core/base/base_read_model.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/account/rules/account_rules.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';

/// A parent, their children, and the faces those children can wear.
///
/// The child setup step shows all three at once — the parent's card, the list,
/// a face beside each name — so they arrive together rather than as three
/// loads a screen has to line up.
///
/// [canAddChild] is the household's limit, `AccountRules.maxChildren`, asked of
/// the household rather than counted in a widget. [hasChild] is whether setup
/// can move on. [avatarOf] finds a child's face in the catalogue, and answers
/// null for a child with none or a face the catalogue no longer carries — which
/// a screen draws as an empty disc rather than failing.
final class HouseholdReadModel extends BaseReadModel {
  const HouseholdReadModel({
    required this.parent,
    required this.children,
    required this.avatars,
  });

  final ParentEntity parent;

  final List<ChildEntity> children;

  final List<AvatarEntity> avatars;

  bool get canAddChild => children.length < AccountRules.maxChildren;

  bool get hasChild => children.isNotEmpty;

  AvatarEntity? avatarOf(ChildEntity child) {
    for (final AvatarEntity avatar in avatars) {
      if (avatar.id == child.avatarId) return avatar;
    }
    return null;
  }

  @override
  List<Object?> get props => <Object?>[parent, children, avatars];
}
