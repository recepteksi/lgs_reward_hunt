import 'package:either_dart/either.dart';
import 'package:lgs_reward_hunt/core/base/base_value_validator.dart';
import 'package:lgs_reward_hunt/core/constants/failure_message_key.dart';
import 'package:lgs_reward_hunt/core/failure/failure.dart';
import 'package:lgs_reward_hunt/domain/task/entities/task_template_entity.dart';

/// Passes a plan whose every line has a topic.
final class TitledTemplatesValidator
    extends BaseValueValidator<List<TaskTemplateEntity>> {
  const TitledTemplatesValidator();

  @override
  Either<Failure, List<TaskTemplateEntity>> validate(
    List<TaskTemplateEntity> value,
  ) => value.every((TaskTemplateEntity template) => template.hasTopic)
      ? Right(value)
      : const Left(ValidationFailure(FailureMessageKey.taskTitleEmpty));
}
