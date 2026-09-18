// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:lgs_reward_hunt/application/account/cubit/child_form/child_form_cubit.dart'
    as _i787;
import 'package:lgs_reward_hunt/application/account/cubit/child_setup/child_setup_cubit.dart'
    as _i417;
import 'package:lgs_reward_hunt/application/account/use_cases/add_child_use_case.dart'
    as _i363;
import 'package:lgs_reward_hunt/application/account/use_cases/load_child_header_use_case.dart'
    as _i899;
import 'package:lgs_reward_hunt/application/account/use_cases/load_device_choice_use_case.dart'
    as _i651;
import 'package:lgs_reward_hunt/application/account/use_cases/load_household_use_case.dart'
    as _i583;
import 'package:lgs_reward_hunt/application/account/use_cases/read_child_snapshot_use_case.dart'
    as _i193;
import 'package:lgs_reward_hunt/application/account/use_cases/remove_child_use_case.dart'
    as _i946;
import 'package:lgs_reward_hunt/application/auth/cubit/auth/auth_cubit.dart'
    as _i618;
import 'package:lgs_reward_hunt/application/auth/cubit/parent_gate/parent_gate_cubit.dart'
    as _i581;
import 'package:lgs_reward_hunt/application/auth/cubit/parent_pin/parent_pin_cubit.dart'
    as _i859;
import 'package:lgs_reward_hunt/application/auth/cubit/password/password_cubit.dart'
    as _i60;
import 'package:lgs_reward_hunt/application/auth/use_cases/open_session_use_case.dart'
    as _i1057;
import 'package:lgs_reward_hunt/application/auth/use_cases/platform_sign_in_use_case.dart'
    as _i379;
import 'package:lgs_reward_hunt/application/auth/use_cases/set_parent_pin_use_case.dart'
    as _i739;
import 'package:lgs_reward_hunt/application/auth/use_cases/sign_in_use_case.dart'
    as _i886;
import 'package:lgs_reward_hunt/application/auth/use_cases/sign_out_use_case.dart'
    as _i885;
import 'package:lgs_reward_hunt/application/auth/use_cases/sign_up_use_case.dart'
    as _i433;
import 'package:lgs_reward_hunt/application/auth/use_cases/verify_parent_pin_use_case.dart'
    as _i723;
import 'package:lgs_reward_hunt/application/avatar/use_cases/load_avatars_use_case.dart'
    as _i566;
import 'package:lgs_reward_hunt/application/exam/use_cases/get_exam_countdown_use_case.dart'
    as _i947;
import 'package:lgs_reward_hunt/application/parent/cubit/parent/parent_cubit.dart'
    as _i975;
import 'package:lgs_reward_hunt/application/parent/use_cases/load_parent_dashboard_use_case.dart'
    as _i388;
import 'package:lgs_reward_hunt/application/profile/cubit/profile/profile_cubit.dart'
    as _i956;
import 'package:lgs_reward_hunt/application/profile/use_cases/load_profile_use_case.dart'
    as _i295;
import 'package:lgs_reward_hunt/application/progress/cubit/progress/progress_cubit.dart'
    as _i170;
import 'package:lgs_reward_hunt/application/progress/use_cases/load_progress_use_case.dart'
    as _i1042;
import 'package:lgs_reward_hunt/application/reward/cubit/reward_setup/reward_setup_cubit.dart'
    as _i1058;
import 'package:lgs_reward_hunt/application/reward/cubit/rewards/rewards_cubit.dart'
    as _i654;
import 'package:lgs_reward_hunt/application/reward/use_cases/add_reward_use_case.dart'
    as _i722;
import 'package:lgs_reward_hunt/application/reward/use_cases/decide_redemption_use_case.dart'
    as _i118;
import 'package:lgs_reward_hunt/application/reward/use_cases/get_reward_shop_use_case.dart'
    as _i632;
import 'package:lgs_reward_hunt/application/reward/use_cases/load_reward_pool_use_case.dart'
    as _i495;
import 'package:lgs_reward_hunt/application/reward/use_cases/remove_reward_use_case.dart'
    as _i942;
import 'package:lgs_reward_hunt/application/reward/use_cases/request_reward_use_case.dart'
    as _i998;
import 'package:lgs_reward_hunt/application/reward/use_cases/save_reward_pool_use_case.dart'
    as _i327;
import 'package:lgs_reward_hunt/application/reward/use_cases/update_reward_use_case.dart'
    as _i990;
import 'package:lgs_reward_hunt/application/session/cubit/device_child/device_child_cubit.dart'
    as _i500;
import 'package:lgs_reward_hunt/application/session/use_cases/choose_device_child_use_case.dart'
    as _i95;
import 'package:lgs_reward_hunt/application/session/use_cases/read_session_use_case.dart'
    as _i329;
import 'package:lgs_reward_hunt/application/session/use_cases/save_session_use_case.dart'
    as _i668;
import 'package:lgs_reward_hunt/application/settings/cubit/appearance/appearance_cubit.dart'
    as _i416;
import 'package:lgs_reward_hunt/application/settings/use_cases/read_appearance_use_case.dart'
    as _i606;
import 'package:lgs_reward_hunt/application/settings/use_cases/save_appearance_use_case.dart'
    as _i548;
import 'package:lgs_reward_hunt/application/study_path/cubit/home/home_cubit.dart'
    as _i478;
import 'package:lgs_reward_hunt/application/study_path/use_cases/load_study_map_use_case.dart'
    as _i638;
import 'package:lgs_reward_hunt/application/task/cubit/task_setup/task_setup_cubit.dart'
    as _i901;
import 'package:lgs_reward_hunt/application/task/use_cases/add_task_series_use_case.dart'
    as _i292;
import 'package:lgs_reward_hunt/application/task/use_cases/complete_task_use_case.dart'
    as _i718;
import 'package:lgs_reward_hunt/application/task/use_cases/delete_task_use_case.dart'
    as _i908;
import 'package:lgs_reward_hunt/application/task/use_cases/load_task_plan_use_case.dart'
    as _i266;
import 'package:lgs_reward_hunt/application/task/use_cases/save_task_plan_use_case.dart'
    as _i894;
import 'package:lgs_reward_hunt/application/task/use_cases/update_task_use_case.dart'
    as _i141;
import 'package:lgs_reward_hunt/domain/account/interfaces/account_repository_interface.dart'
    as _i835;
import 'package:lgs_reward_hunt/domain/account/interfaces/child_snapshot_cache_interface.dart'
    as _i567;
import 'package:lgs_reward_hunt/domain/auth/interfaces/auth_repository_interface.dart'
    as _i803;
import 'package:lgs_reward_hunt/domain/auth/interfaces/platform_sign_in_interface.dart'
    as _i958;
import 'package:lgs_reward_hunt/domain/avatar/interfaces/avatar_repository_interface.dart'
    as _i945;
import 'package:lgs_reward_hunt/domain/exam/interfaces/exam_schedule_repository_interface.dart'
    as _i840;
import 'package:lgs_reward_hunt/domain/points/interfaces/points_repository_interface.dart'
    as _i727;
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_pool_repository_interface.dart'
    as _i1050;
import 'package:lgs_reward_hunt/domain/reward/interfaces/reward_repository_interface.dart'
    as _i705;
import 'package:lgs_reward_hunt/domain/session/interfaces/session_repository_interface.dart'
    as _i784;
import 'package:lgs_reward_hunt/domain/settings/interfaces/appearance_repository_interface.dart'
    as _i467;
import 'package:lgs_reward_hunt/domain/task/interfaces/task_plan_repository_interface.dart'
    as _i847;
import 'package:lgs_reward_hunt/domain/task/interfaces/task_repository_interface.dart'
    as _i335;
import 'package:lgs_reward_hunt/infrastructure/account/repositories/account_repository.dart'
    as _i597;
import 'package:lgs_reward_hunt/infrastructure/account/repositories/child_snapshot_cache_repository.dart'
    as _i776;
import 'package:lgs_reward_hunt/infrastructure/auth/repositories/auth_repository.dart'
    as _i613;
import 'package:lgs_reward_hunt/infrastructure/auth/services/firebase_platform_sign_in_service.dart'
    as _i414;
import 'package:lgs_reward_hunt/infrastructure/avatar/repositories/avatar_repository.dart'
    as _i484;
import 'package:lgs_reward_hunt/infrastructure/exam/repositories/exam_schedule_repository.dart'
    as _i916;
import 'package:lgs_reward_hunt/infrastructure/network/crypto/passthrough_payload_codec.dart'
    as _i315;
import 'package:lgs_reward_hunt/infrastructure/network/crypto/payload_codec_interface.dart'
    as _i233;
import 'package:lgs_reward_hunt/infrastructure/network/dio_client.dart'
    as _i527;
import 'package:lgs_reward_hunt/infrastructure/points/repositories/points_repository.dart'
    as _i948;
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_pool_repository.dart'
    as _i842;
import 'package:lgs_reward_hunt/infrastructure/reward/repositories/reward_repository.dart'
    as _i432;
import 'package:lgs_reward_hunt/infrastructure/session/repositories/session_repository.dart'
    as _i770;
import 'package:lgs_reward_hunt/infrastructure/settings/repositories/appearance_repository.dart'
    as _i628;
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_plan_repository.dart'
    as _i294;
import 'package:lgs_reward_hunt/infrastructure/task/repositories/task_repository.dart'
    as _i214;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.lazySingleton<_i958.PlatformSignInInterface>(
    () => _i414.FirebasePlatformSignInService(),
  );
  gh.lazySingleton<_i467.AppearanceRepositoryInterface>(
    () => const _i628.AppearanceRepository(),
  );
  gh.lazySingleton<_i567.ChildSnapshotCacheInterface>(
    () => _i776.ChildSnapshotCacheRepository(),
  );
  gh.lazySingleton<_i784.SessionRepositoryInterface>(
    () => const _i770.SessionRepository(),
  );
  gh.lazySingleton<_i840.ExamScheduleRepositoryInterface>(
    () => const _i916.ExamScheduleRepository(),
  );
  gh.factory<_i885.SignOutUseCase>(
    () => _i885.SignOutUseCase(
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i958.PlatformSignInInterface>(),
      gh<_i567.ChildSnapshotCacheInterface>(),
    ),
  );
  gh.factory<_i193.ReadChildSnapshotUseCase>(
    () =>
        _i193.ReadChildSnapshotUseCase(gh<_i567.ChildSnapshotCacheInterface>()),
  );
  gh.lazySingleton<_i233.PayloadCodecInterface>(
    () => const _i315.PassthroughPayloadCodec(),
  );
  gh.factory<_i606.ReadAppearanceUseCase>(
    () =>
        _i606.ReadAppearanceUseCase(gh<_i467.AppearanceRepositoryInterface>()),
  );
  gh.factory<_i548.SaveAppearanceUseCase>(
    () =>
        _i548.SaveAppearanceUseCase(gh<_i467.AppearanceRepositoryInterface>()),
  );
  gh.factory<_i95.ChooseDeviceChildUseCase>(
    () => _i95.ChooseDeviceChildUseCase(
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i567.ChildSnapshotCacheInterface>(),
    ),
  );
  gh.factory<_i947.GetExamCountdownUseCase>(
    () => _i947.GetExamCountdownUseCase(
      gh<_i840.ExamScheduleRepositoryInterface>(),
    ),
  );
  gh.lazySingleton<_i527.DioClient>(
    () => _i527.DioClient(gh<_i233.PayloadCodecInterface>()),
  );
  gh.lazySingleton<_i416.AppearanceCubit>(
    () => _i416.AppearanceCubit(
      gh<_i606.ReadAppearanceUseCase>(),
      gh<_i548.SaveAppearanceUseCase>(),
    ),
  );
  gh.lazySingleton<_i847.TaskPlanRepositoryInterface>(
    () => _i294.TaskPlanRepository(gh<_i527.DioClient>()),
  );
  gh.lazySingleton<_i803.AuthRepositoryInterface>(
    () => _i613.AuthRepository(gh<_i527.DioClient>()),
  );
  gh.factory<_i329.ReadSessionUseCase>(
    () => _i329.ReadSessionUseCase(gh<_i784.SessionRepositoryInterface>()),
  );
  gh.factory<_i668.SaveSessionUseCase>(
    () => _i668.SaveSessionUseCase(gh<_i784.SessionRepositoryInterface>()),
  );
  gh.lazySingleton<_i1050.RewardPoolRepositoryInterface>(
    () => _i842.RewardPoolRepository(gh<_i527.DioClient>()),
  );
  gh.factory<_i495.LoadRewardPoolUseCase>(
    () => _i495.LoadRewardPoolUseCase(
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i1050.RewardPoolRepositoryInterface>(),
    ),
  );
  gh.factory<_i327.SaveRewardPoolUseCase>(
    () => _i327.SaveRewardPoolUseCase(
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i1050.RewardPoolRepositoryInterface>(),
    ),
  );
  gh.lazySingleton<_i945.AvatarRepositoryInterface>(
    () => _i484.AvatarRepository(gh<_i527.DioClient>()),
  );
  gh.lazySingleton<_i835.AccountRepositoryInterface>(
    () => _i597.AccountRepository(gh<_i527.DioClient>()),
  );
  gh.factory<_i266.LoadTaskPlanUseCase>(
    () => _i266.LoadTaskPlanUseCase(
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i847.TaskPlanRepositoryInterface>(),
    ),
  );
  gh.factory<_i894.SaveTaskPlanUseCase>(
    () => _i894.SaveTaskPlanUseCase(
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i847.TaskPlanRepositoryInterface>(),
    ),
  );
  gh.lazySingleton<_i727.PointsRepositoryInterface>(
    () => _i948.PointsRepository(gh<_i527.DioClient>()),
  );
  gh.lazySingleton<_i335.TaskRepositoryInterface>(
    () => _i214.TaskRepository(gh<_i527.DioClient>()),
  );
  gh.lazySingleton<_i705.RewardRepositoryInterface>(
    () => _i432.RewardRepository(gh<_i527.DioClient>()),
  );
  gh.factory<_i379.PlatformSignInUseCase>(
    () => _i379.PlatformSignInUseCase(
      gh<_i958.PlatformSignInInterface>(),
      gh<_i803.AuthRepositoryInterface>(),
    ),
  );
  gh.factory<_i1058.RewardSetupCubit>(
    () => _i1058.RewardSetupCubit(
      gh<_i495.LoadRewardPoolUseCase>(),
      gh<_i327.SaveRewardPoolUseCase>(),
      gh<_i266.LoadTaskPlanUseCase>(),
    ),
  );
  gh.factory<_i566.LoadAvatarsUseCase>(
    () => _i566.LoadAvatarsUseCase(gh<_i945.AvatarRepositoryInterface>()),
  );
  gh.factory<_i292.AddTaskSeriesUseCase>(
    () => _i292.AddTaskSeriesUseCase(gh<_i335.TaskRepositoryInterface>()),
  );
  gh.factory<_i718.CompleteTaskUseCase>(
    () => _i718.CompleteTaskUseCase(gh<_i335.TaskRepositoryInterface>()),
  );
  gh.factory<_i908.DeleteTaskUseCase>(
    () => _i908.DeleteTaskUseCase(gh<_i335.TaskRepositoryInterface>()),
  );
  gh.factory<_i141.UpdateTaskUseCase>(
    () => _i141.UpdateTaskUseCase(gh<_i335.TaskRepositoryInterface>()),
  );
  gh.factory<_i583.LoadHouseholdUseCase>(
    () => _i583.LoadHouseholdUseCase(
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i835.AccountRepositoryInterface>(),
      gh<_i945.AvatarRepositoryInterface>(),
    ),
  );
  gh.factory<_i901.TaskSetupCubit>(
    () => _i901.TaskSetupCubit(
      gh<_i266.LoadTaskPlanUseCase>(),
      gh<_i894.SaveTaskPlanUseCase>(),
    ),
  );
  gh.factory<_i632.GetRewardShopUseCase>(
    () => _i632.GetRewardShopUseCase(
      gh<_i835.AccountRepositoryInterface>(),
      gh<_i727.PointsRepositoryInterface>(),
      gh<_i705.RewardRepositoryInterface>(),
      gh<_i567.ChildSnapshotCacheInterface>(),
    ),
  );
  gh.factory<_i363.AddChildUseCase>(
    () => _i363.AddChildUseCase(
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i835.AccountRepositoryInterface>(),
    ),
  );
  gh.factory<_i946.RemoveChildUseCase>(
    () => _i946.RemoveChildUseCase(
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i835.AccountRepositoryInterface>(),
    ),
  );
  gh.factory<_i739.SetParentPinUseCase>(
    () => _i739.SetParentPinUseCase(gh<_i803.AuthRepositoryInterface>()),
  );
  gh.factory<_i886.SignInUseCase>(
    () => _i886.SignInUseCase(gh<_i803.AuthRepositoryInterface>()),
  );
  gh.factory<_i433.SignUpUseCase>(
    () => _i433.SignUpUseCase(gh<_i803.AuthRepositoryInterface>()),
  );
  gh.factory<_i723.VerifyParentPinUseCase>(
    () => _i723.VerifyParentPinUseCase(gh<_i803.AuthRepositoryInterface>()),
  );
  gh.factory<_i722.AddRewardUseCase>(
    () => _i722.AddRewardUseCase(gh<_i705.RewardRepositoryInterface>()),
  );
  gh.factory<_i118.DecideRedemptionUseCase>(
    () => _i118.DecideRedemptionUseCase(gh<_i705.RewardRepositoryInterface>()),
  );
  gh.factory<_i942.RemoveRewardUseCase>(
    () => _i942.RemoveRewardUseCase(gh<_i705.RewardRepositoryInterface>()),
  );
  gh.factory<_i998.RequestRewardUseCase>(
    () => _i998.RequestRewardUseCase(gh<_i705.RewardRepositoryInterface>()),
  );
  gh.factory<_i990.UpdateRewardUseCase>(
    () => _i990.UpdateRewardUseCase(gh<_i705.RewardRepositoryInterface>()),
  );
  gh.factory<_i1057.OpenSessionUseCase>(
    () => _i1057.OpenSessionUseCase(
      gh<_i835.AccountRepositoryInterface>(),
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i567.ChildSnapshotCacheInterface>(),
    ),
  );
  gh.factory<_i60.PasswordCubit>(
    () => _i60.PasswordCubit(
      gh<_i433.SignUpUseCase>(),
      gh<_i668.SaveSessionUseCase>(),
    ),
  );
  gh.factory<_i899.LoadChildHeaderUseCase>(
    () => _i899.LoadChildHeaderUseCase(
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i835.AccountRepositoryInterface>(),
      gh<_i945.AvatarRepositoryInterface>(),
      gh<_i567.ChildSnapshotCacheInterface>(),
    ),
  );
  gh.factory<_i859.ParentPinCubit>(
    () => _i859.ParentPinCubit(
      gh<_i329.ReadSessionUseCase>(),
      gh<_i739.SetParentPinUseCase>(),
    ),
  );
  gh.factory<_i638.LoadStudyMapUseCase>(
    () => _i638.LoadStudyMapUseCase(
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i835.AccountRepositoryInterface>(),
      gh<_i945.AvatarRepositoryInterface>(),
      gh<_i727.PointsRepositoryInterface>(),
      gh<_i335.TaskRepositoryInterface>(),
      gh<_i840.ExamScheduleRepositoryInterface>(),
      gh<_i567.ChildSnapshotCacheInterface>(),
    ),
  );
  gh.factory<_i1042.LoadProgressUseCase>(
    () => _i1042.LoadProgressUseCase(
      gh<_i727.PointsRepositoryInterface>(),
      gh<_i335.TaskRepositoryInterface>(),
      gh<_i567.ChildSnapshotCacheInterface>(),
    ),
  );
  gh.factory<_i478.HomeCubit>(
    () => _i478.HomeCubit(
      gh<_i638.LoadStudyMapUseCase>(),
      gh<_i718.CompleteTaskUseCase>(),
      gh<_i193.ReadChildSnapshotUseCase>(),
    ),
  );
  gh.factory<_i618.AuthCubit>(
    () => _i618.AuthCubit(
      gh<_i886.SignInUseCase>(),
      gh<_i379.PlatformSignInUseCase>(),
      gh<_i1057.OpenSessionUseCase>(),
    ),
  );
  gh.factory<_i417.ChildSetupCubit>(
    () => _i417.ChildSetupCubit(
      gh<_i583.LoadHouseholdUseCase>(),
      gh<_i946.RemoveChildUseCase>(),
    ),
  );
  gh.factory<_i787.ChildFormCubit>(
    () => _i787.ChildFormCubit(
      gh<_i566.LoadAvatarsUseCase>(),
      gh<_i363.AddChildUseCase>(),
    ),
  );
  gh.factory<_i295.LoadProfileUseCase>(
    () => _i295.LoadProfileUseCase(
      gh<_i899.LoadChildHeaderUseCase>(),
      gh<_i1042.LoadProgressUseCase>(),
      gh<_i835.AccountRepositoryInterface>(),
      gh<_i840.ExamScheduleRepositoryInterface>(),
    ),
  );
  gh.factory<_i956.ProfileCubit>(
    () => _i956.ProfileCubit(
      gh<_i295.LoadProfileUseCase>(),
      gh<_i193.ReadChildSnapshotUseCase>(),
    ),
  );
  gh.factory<_i651.LoadDeviceChoiceUseCase>(
    () => _i651.LoadDeviceChoiceUseCase(
      gh<_i583.LoadHouseholdUseCase>(),
      gh<_i727.PointsRepositoryInterface>(),
      gh<_i784.SessionRepositoryInterface>(),
    ),
  );
  gh.factory<_i581.ParentGateCubit>(
    () => _i581.ParentGateCubit(
      gh<_i329.ReadSessionUseCase>(),
      gh<_i723.VerifyParentPinUseCase>(),
    ),
  );
  gh.factory<_i388.LoadParentDashboardUseCase>(
    () => _i388.LoadParentDashboardUseCase(
      gh<_i784.SessionRepositoryInterface>(),
      gh<_i583.LoadHouseholdUseCase>(),
      gh<_i1042.LoadProgressUseCase>(),
      gh<_i705.RewardRepositoryInterface>(),
      gh<_i335.TaskRepositoryInterface>(),
      gh<_i840.ExamScheduleRepositoryInterface>(),
      gh<_i1050.RewardPoolRepositoryInterface>(),
    ),
  );
  gh.factory<_i654.RewardsCubit>(
    () => _i654.RewardsCubit(
      gh<_i899.LoadChildHeaderUseCase>(),
      gh<_i632.GetRewardShopUseCase>(),
      gh<_i998.RequestRewardUseCase>(),
      gh<_i193.ReadChildSnapshotUseCase>(),
    ),
  );
  gh.factory<_i975.ParentCubit>(
    () => _i975.ParentCubit(
      gh<_i388.LoadParentDashboardUseCase>(),
      gh<_i118.DecideRedemptionUseCase>(),
      gh<_i95.ChooseDeviceChildUseCase>(),
      gh<_i292.AddTaskSeriesUseCase>(),
      gh<_i141.UpdateTaskUseCase>(),
      gh<_i908.DeleteTaskUseCase>(),
      gh<_i722.AddRewardUseCase>(),
      gh<_i990.UpdateRewardUseCase>(),
      gh<_i942.RemoveRewardUseCase>(),
      gh<_i885.SignOutUseCase>(),
    ),
  );
  gh.factory<_i170.ProgressCubit>(
    () => _i170.ProgressCubit(
      gh<_i899.LoadChildHeaderUseCase>(),
      gh<_i1042.LoadProgressUseCase>(),
      gh<_i193.ReadChildSnapshotUseCase>(),
    ),
  );
  gh.factory<_i500.DeviceChildCubit>(
    () => _i500.DeviceChildCubit(
      gh<_i651.LoadDeviceChoiceUseCase>(),
      gh<_i95.ChooseDeviceChildUseCase>(),
    ),
  );
  return getIt;
}
