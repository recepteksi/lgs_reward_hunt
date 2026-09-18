import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_entity.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/rules/account_rules.dart';

/// The student the app is for.
///
/// A child always belongs to a [parentId]; there is no unattached child. The
/// link is established once, with the parent's code, and everything the child
/// can see or spend is scoped by it.
///
/// [gradeLevel] is 8 for everyone sitting the LGS this year, but it is a field
/// rather than a constant because the year below starts using the app in
/// spring and their countdown points at a different exam.
///
/// [avatarId] is the face the parent picked. It is null for a child who joined
/// with a link code, who has not picked one yet.
final class ChildEntity extends BaseEntity {
  const ChildEntity._({
    required this.id,
    required this.parentId,
    required this.name,
    required this.gradeLevel,
    required this.avatarId,
  });

  @override
  final String id;

  final String parentId;

  final String name;

  final int gradeLevel;

  final String? avatarId;

  static Either<Failure, ChildEntity> create({
    required String id,
    required String parentId,
    required String name,
    int gradeLevel = AccountRules.defaultGradeLevel,
    String? avatarId,
  }) {
    if (name.trim().isEmpty) {
      return const Left(ValidationFailure(FailureMessageKey.childNameEmpty));
    }
    return Right(
      ChildEntity._(
        id: id,
        parentId: parentId,
        name: name.trim(),
        gradeLevel: gradeLevel,
        avatarId: avatarId,
      ),
    );
  }
}
