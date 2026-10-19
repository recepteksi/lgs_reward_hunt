import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_entity.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';

/// The account that owns everything: tasks, rewards and approvals.
///
/// The parent is created first and the child joins them, never the other way
/// round. That order is the product: a child who could create their own
/// account could also create their own rewards, and the approval the whole
/// loop rests on would be a formality.
///
/// [linkCode] is what the parent reads out to the child once. It lives on the
/// parent rather than in a table of its own because a parent has exactly one
/// at a time and a code with no parent is not a thing that can exist.
///
/// [initial] is the letter on the parent's round badge, upper-cased the Turkish
/// way: a name starting with `i` gets a dotted capital, which Dart's
/// locale-blind `toUpperCase` would get wrong.
final class ParentEntity extends BaseEntity {
  const ParentEntity._({
    required this.id,
    required this.name,
    required this.email,
    required this.linkCode,
  });

  @override
  final String id;

  final String name;

  final String email;

  final String linkCode;

  static const String _dotlessLower = 'i';

  static const String _dottedUpper = 'İ';

  String get initial {
    if (name.isEmpty) return name;
    final String first = name.substring(
      ValueConstants.zero,
      ValueConstants.one,
    );

    return first == _dotlessLower ? _dottedUpper : first.toUpperCase();
  }

  static Either<Failure, ParentEntity> create({
    required String id,
    required String name,
    required String email,
    required String linkCode,
  }) {
    if (name.trim().isEmpty) {
      return const Left(ValidationFailure(FailureMessageKey.parentNameEmpty));
    }
    return Right(
      ParentEntity._(
        id: id,
        name: name.trim(),
        email: email.trim().toLowerCase(),
        linkCode: linkCode,
      ),
    );
  }
}
