import 'package:lgs_reward_hunt/core/base/base_value_object.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';

/// Who is using the app right now.
///
/// One parent account and, under it, the child whose map is on screen. Both are
/// ids rather than entities: this is what gets written to the device and read
/// back before the first frame, and storing a whole account there would mean a
/// stale name surviving a rename. Nothing to validate — any pair of ids,
/// including none, is a session — so [validators] is empty.
///
/// [activeChildId] is null in the gap between a parent signing up and their
/// first child being added — a real state, not a broken one, and the reason the
/// setup flow can be resumed after the app is killed.
///
/// [none] is a device nobody has signed in on yet. [withoutChild] is the same
/// parent with no child on screen — what is left when the active child is
/// removed during setup, and something `copyWith` cannot say, because a null
/// there means "unchanged".
final class SessionValueObject
    extends BaseValueObject<({String? parentId, String? activeChildId})> {
  const SessionValueObject({
    required String? parentId,
    required String? activeChildId,
  }) : super((parentId: parentId, activeChildId: activeChildId));

  static const SessionValueObject none = SessionValueObject(
    parentId: null,
    activeChildId: null,
  );

  String? get parentId => value.parentId;

  String? get activeChildId => value.activeChildId;

  bool get isSignedIn => parentId != null;

  bool get hasChild => activeChildId != null;

  SessionValueObject copyWith({String? parentId, String? activeChildId}) =>
      SessionValueObject(
        parentId: parentId ?? this.parentId,
        activeChildId: activeChildId ?? this.activeChildId,
      );

  SessionValueObject withoutChild() =>
      SessionValueObject(parentId: parentId, activeChildId: null);

  @override
  List<BaseValueValidator<({String? parentId, String? activeChildId})>>
  get validators => const [];
}
