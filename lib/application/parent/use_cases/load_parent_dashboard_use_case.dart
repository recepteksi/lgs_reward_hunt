import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/account/use_cases/load_household_use_case.dart';
import 'package:lgs_reward_hunt/application/progress/use_cases/load_progress_use_case.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/account/entities/child_entity.dart';
import 'package:lgs_reward_hunt/domain/exam/interfaces/exam_schedule_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/parent/read_models/parent_dashboard_read_model.dart';
import 'package:lgs_reward_hunt/domain/parent/rules/parent_rules.dart';
import 'package:lgs_reward_hunt/domain/reward/entities/redemption_entity.dart';
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_pool_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart';
import 'package:lgs_reward_hunt/domain/task/interfaces/task_repository_interface.dart';

/// Reads the parent's side for the child this device is on.
///
/// The household and the child's progress come from the use cases the setup
/// and progress pages already use, so the streak and balance here are the
/// child's own tabs' figures. The device's child is the session's; if the
/// session names none, the household's first child stands in. `now` is passed
/// in so a test can stand on any day.
@injectable
final class LoadParentDashboardUseCase {
  const LoadParentDashboardUseCase(
    this._session,
    this._loadHousehold,
    this._loadProgress,
    this._rewards,
    this._tasks,
    this._exams,
    this._pools,
  );

  final SessionRepositoryInterface _session;

  final LoadHouseholdUseCase _loadHousehold;

  final LoadProgressUseCase _loadProgress;

  final RewardRepositoryInterface _rewards;

  final TaskRepositoryInterface _tasks;

  final ExamScheduleRepositoryInterface _exams;

  final RewardPoolRepositoryInterface _pools;

  Future<Either<Failure, ParentDashboardReadModel>> call({
    required DateTime now,
  }) async {
    final household = await _loadHousehold();
    if (household.isLeft) return Left(household.left);
    if (!household.right.hasChild) {
      return const Left(ValidationFailure(FailureMessageKey.notSignedIn));
    }

    final session = await _session.read();
    if (session.isLeft) return Left(session.left);
    ChildEntity child = household.right.children.first;
    for (final ChildEntity candidate in household.right.children) {
      if (candidate.id == session.right.activeChildId) child = candidate;
    }

    final progress = await _loadProgress(childId: child.id, now: now);
    if (progress.isLeft) return Left(progress.left);

    final String parentId = household.right.parent.id;
    final pending = await _rewards.pendingForParent(parentId);
    if (pending.isLeft) return Left(pending.left);

    final rewards = await _rewards.rewardsFor(parentId);
    if (rewards.isLeft) return Left(rewards.left);

    final DateTime today = DateTime(now.year, now.month, now.day);
    final tasks = await _tasks.tasksBetween(
      childId: child.id,
      from: today,
      to: DateTime(
        today.year,
        today.month,
        today.day + ParentRules.dayStripDays - 1,
      ),
    );
    if (tasks.isLeft) return Left(tasks.left);

    final exam = await _exams.nextExamAfter(now);
    if (exam.isLeft) return Left(exam.left);

    final presets = await _pools.standardPool();
    if (presets.isLeft) return Left(presets.left);

    return Right(
      ParentDashboardReadModel(
        household: household.right,
        activeChild: child,
        balance: progress.right.account.balance,
        streakDays: progress.right.streakDays,
        pending: List<RedemptionEntity>.of(pending.right)
          ..sort(
            (RedemptionEntity a, RedemptionEntity b) =>
                a.requestedAt.compareTo(b.requestedAt),
          ),
        rewards: rewards.right,
        weekTasks: tasks.right,
        today: today,
        examDate: exam.right,
        presets: presets.right.rewards,
      ),
    );
  }
}
