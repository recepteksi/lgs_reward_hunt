import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// One line of the scale: the sample, and the spec under it.
class UiKitSpecimen extends StatelessWidget {
  const UiKitSpecimen({required this.spec, required this.child, super.key});

  final String spec;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        child,
        const SizedBox(height: AppSpacing.xs),
        AppText(spec, type: AppTextTypeEnum.caption),
      ],
    );
  }
}
