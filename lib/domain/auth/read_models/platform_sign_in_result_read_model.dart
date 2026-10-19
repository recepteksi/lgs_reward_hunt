import 'package:lgs_reward_hunt/core/base/base_read_model.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';

/// What the backend made of a platform sign-in: the parent's account, and
/// whether it was opened just now.
///
/// [isNewAccount] decides where setup goes next — a new parent still has a PIN
/// and a child to set up, a returning one does not.
final class PlatformSignInResultReadModel extends BaseReadModel {
  const PlatformSignInResultReadModel({
    required this.parent,
    required this.isNewAccount,
  });

  final ParentEntity parent;

  final bool isNewAccount;

  @override
  List<Object?> get props => <Object?>[parent, isNewAccount];
}
