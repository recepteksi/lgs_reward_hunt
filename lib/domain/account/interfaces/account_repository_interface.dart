import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/account/value_objects/child_profile_value_object.dart';

/// Creating the two accounts and tying them together.
///
/// [createParent] opens the household and returns the parent carrying the link
/// code, and [parentById] reads it back. [addChild] is the parent adding a
/// child directly, on their own device, from a validated profile;
/// [childrenOf] lists the ones they have and [removeChild] takes one away
/// again while setup is still open. [linkChild] is the child's side: a code typed on the child's phone
/// that attaches them to the parent who read it out.
///
/// Both routes exist because both happen — a parent setting up the whole thing
/// on one phone, and a parent who has to get their child's phone involved.
abstract interface class AccountRepositoryInterface {
  Future<Either<Failure, ParentEntity>> createParent({required String name});

  Future<Either<Failure, ParentEntity>> parentById(String parentId);

  Future<Either<Failure, ChildEntity>> addChild({
    required String parentId,
    required ChildProfileValueObject profile,
  });

  Future<Either<Failure, List<ChildEntity>>> childrenOf(String parentId);

  Future<Either<Failure, void>> removeChild(String childId);

  Future<Either<Failure, ChildEntity>> linkChild({
    required String linkCode,
    required String name,
  });

  Future<Either<Failure, ChildEntity>> childById(String childId);
}
