import 'package:json_annotation/json_annotation.dart';
import 'package:lgs_reward_hunt/infrastructure/network/dto/base_request.dart';
import 'package:lgs_reward_hunt/infrastructure/task/dto/task_template_request_dto.dart';

part 'save_task_plan_request_dto.g.dart';

/// A whole task plan, sent to replace the stored one.
///
/// The server writes the household's tasks from it, starting today by its own
/// clock — the device does not say which day "today" is, because a phone with
/// the wrong date would otherwise schedule a fortnight in the wrong place.
@JsonSerializable(createFactory: false, explicitToJson: true)
final class SaveTaskPlanRequestDto extends BaseRequest {
  const SaveTaskPlanRequestDto({required this.templates});

  final List<TaskTemplateRequestDto> templates;

  @override
  Map<String, dynamic> toJson() => _$SaveTaskPlanRequestDtoToJson(this);
}
