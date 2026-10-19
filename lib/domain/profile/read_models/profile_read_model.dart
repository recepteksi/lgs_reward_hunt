import 'package:lgs_reward_hunt/core/base/base_read_model.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_header_read_model.dart';
import 'package:lgs_reward_hunt/domain/progress/read_models/progress_read_model.dart';

/// Everything the profile tab shows: who the child is, how they are doing, the
/// exam they are working towards, and the parent they are linked to.
///
/// A snapshot put together for one page; every figure in it is its parts'.
final class ProfileReadModel extends BaseReadModel {
  const ProfileReadModel({
    required this.header,
    required this.progress,
    required this.examDate,
    required this.parent,
  });

  final ChildHeaderReadModel header;

  final ProgressReadModel progress;

  final DateTime examDate;

  final ParentEntity parent;

  @override
  List<Object?> get props => <Object?>[header, progress, examDate, parent];
}
