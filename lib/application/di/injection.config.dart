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
import 'package:lgs_reward_hunt/application/exam/exam_countdown_cubit.dart'
    as _i241;
import 'package:lgs_reward_hunt/application/exam/get_exam_countdown_use_case.dart'
    as _i531;
import 'package:lgs_reward_hunt/domain/exam/exam_schedule_repository_interface.dart'
    as _i29;
import 'package:lgs_reward_hunt/infrastructure/exam/exam_schedule_repository.dart'
    as _i836;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.lazySingleton<_i29.ExamScheduleRepositoryInterface>(
    () => const _i836.ExamScheduleRepository(),
  );
  gh.factory<_i531.GetExamCountdownUseCase>(
    () => _i531.GetExamCountdownUseCase(
      gh<_i29.ExamScheduleRepositoryInterface>(),
    ),
  );
  gh.factory<_i241.ExamCountdownCubit>(
    () => _i241.ExamCountdownCubit(gh<_i531.GetExamCountdownUseCase>()),
  );
  return getIt;
}
