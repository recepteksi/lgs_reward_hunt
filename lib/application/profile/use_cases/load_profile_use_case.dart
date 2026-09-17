import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_child_header_use_case.dart';
import 'package:lgs_reward_hunt/application/progress/use_cases/load_progress_use_case.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/interfaces/account_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/exam/interfaces/exam_schedule_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/profile/read_models/profile_read_model.dart';

/// Reads the profile tab: the child, their progress, the next exam and their
/// parent.
///
/// It is built from the use cases the other tabs already use for whose tab it
/// is and for progress, so the profile's level and streak are the progress
/// tab's, not a second calculation. `now` is passed in so a test can stand on
/// any day.
@injectable
final class LoadProfileUseCase {
  const LoadProfileUseCase(
    this._loadHeader,
    this._loadProgress,
    this._accounts,
    this._exams,
  );

  final LoadChildHeaderUseCase _loadHeader;

  final LoadProgressUseCase _loadProgress;

  final AccountRepositoryInterface _accounts;

  final ExamScheduleRepositoryInterface _exams;

  Future<Either<Failure, ProfileReadModel>> call({
    required DateTime now,
  }) async {
    final header = await _loadHeader();
    if (header.isLeft) return Left(header.left);

    final progress = await _loadProgress(
      childId: header.right.child.id,
      now: now,
    );
    if (progress.isLeft) return Left(progress.left);

    final parent = await _accounts.parentById(header.right.child.parentId);
    if (parent.isLeft) return Left(parent.left);

    final exam = await _exams.nextExamAfter(now);
    if (exam.isLeft) return Left(exam.left);

    return Right(
      ProfileReadModel(
        header: header.right,
        progress: progress.right,
        examDate: exam.right,
        parent: parent.right,
      ),
    );
  }
}
