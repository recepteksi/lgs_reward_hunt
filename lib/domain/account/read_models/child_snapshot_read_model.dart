import 'package:lgs_reward_hunt/core/base/base_read_model.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_header_read_model.dart';

/// What is already known about the child on screen, before anything loads.
///
/// A page opening does not have to wait to say whose it is: the name, face and
/// balance were read by whichever tab loaded last. [header] is the child and
/// their face, [balance] their points; either is null until something has read
/// it. [empty] is a fresh launch. [withHeader] and [withBalance] answer a new
/// snapshot with one part replaced.
final class ChildSnapshotReadModel extends BaseReadModel {
  const ChildSnapshotReadModel({required this.header, required this.balance});

  static const ChildSnapshotReadModel empty = ChildSnapshotReadModel(
    header: null,
    balance: null,
  );

  final ChildHeaderReadModel? header;

  final int? balance;

  ChildSnapshotReadModel withHeader(ChildHeaderReadModel header) =>
      ChildSnapshotReadModel(header: header, balance: balance);

  ChildSnapshotReadModel withBalance(int balance) =>
      ChildSnapshotReadModel(header: header, balance: balance);

  @override
  List<Object?> get props => <Object?>[header, balance];
}
