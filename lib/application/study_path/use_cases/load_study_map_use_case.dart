import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/account_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/child_snapshot_cache_interface.dart';
import 'package:lgs_reward_hunt/domain/account/read_models/child_header_read_model.dart';
import 'package:lgs_reward_hunt/domain/avatar/entities/avatar_entity.dart';
import 'package:lgs_reward_hunt/domain/avatar/interfaces/avatar_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/exam/interfaces/exam_schedule_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/points/interfaces/points_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/study_path/read_models/study_map_read_model.dart';
import 'package:lgs_reward_hunt/domain/study_path/read_models/study_path_read_model.dart';
import 'package:lgs_reward_hunt/domain/study_path/rules/study_map_rules.dart';
import 'package:lgs_reward_hunt/domain/task/interfaces/task_repository_interface.dart';

/// Reads the home map for the child this device opens on.
///
/// The child comes from the session. The window of days is the path's own —
/// from `StudyMapRules.stopsBeforeToday` days back, `StudyMapRules.visibleStops`
/// long — and its tasks are read in one range request; the path is then built
/// from them by `StudyPathReadModel.build`, which is where the rules for
/// what a stop is live. `now` is passed in so a test can stand on any day.
///
/// The map's child, face and balance are remembered in the child snapshot.
@injectable
final class LoadStudyMapUseCase {
  const LoadStudyMapUseCase(
    this._session,
    this._accounts,
    this._avatars,
    this._points,
    this._tasks,
    this._exams,
    this._snapshots,
  );

  final SessionRepositoryInterface _session;

  final AccountRepositoryInterface _accounts;

  final AvatarRepositoryInterface _avatars;

  final PointsRepositoryInterface _points;

  final TaskRepositoryInterface _tasks;

  final ExamScheduleRepositoryInterface _exams;

  final ChildSnapshotCacheInterface _snapshots;

  Future<Either<Failure, StudyMapReadModel>> call({
    required DateTime now,
  }) async {
    final session = await _session.read();
    if (session.isLeft) return Left(session.left);

    final String? childId = session.right.activeChildId;
    if (childId == null) {
      return const Left(UnauthorizedFailure(FailureMessageKey.notSignedIn));
    }

    final child = await _accounts.childById(childId);
    if (child.isLeft) return Left(child.left);

    final catalog = await _avatars.catalog();
    if (catalog.isLeft) return Left(catalog.left);

    final account = await _points.accountFor(childId);
    if (account.isLeft) return Left(account.left);

    final exam = await _exams.nextExamAfter(now);
    if (exam.isLeft) return Left(exam.left);

    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime from = DateTime(
      today.year,
      today.month,
      today.day - StudyMapRules.stopsBeforeToday,
    );
    final DateTime to = DateTime(
      from.year,
      from.month,
      from.day + StudyMapRules.visibleStops - 1,
    );
    final tasks = await _tasks.tasksBetween(
      childId: childId,
      from: from,
      to: to,
    );
    if (tasks.isLeft) return Left(tasks.left);

    AvatarEntity? avatar;
    for (final AvatarEntity face in catalog.right) {
      if (face.id == child.right.avatarId) avatar = face;
    }

    _snapshots.write(
      _snapshots.snapshot
          .withHeader(ChildHeaderReadModel(child: child.right, avatar: avatar))
          .withBalance(account.right.balance),
    );

    return Right(
      StudyMapReadModel(
        child: child.right,
        avatar: avatar,
        balance: account.right.balance,
        path: StudyPathReadModel.build(
          tasks: tasks.right,
          today: now,
          examDate: exam.right,
        ),
      ),
    );
  }
}
