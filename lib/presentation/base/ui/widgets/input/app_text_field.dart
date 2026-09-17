import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// A labelled field, in the shape every form in this app uses.
///
/// The label sits above the box in tracked capitals rather than floating inside
/// it: a floating label is animation for its own sake, and on a form a parent
/// fills in once it costs a beat of comprehension for nothing.
///
/// [error] turns the border and adds the line underneath. It is a string rather
/// than a bool because the sentence is the useful part — "Şifreler aynı değil"
/// tells a parent what to do, a red outline does not.
///
/// [obscure] hides the text and [trailing] is where the show/hide control goes,
/// which is the one thing a password field needs that a text field does not.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    required this.controller,
    this.hint,
    this.error,
    this.keyboardType,
    this.obscure = false,
    this.trailing,
    this.onChanged,
    super.key,
  });

  static const double _height = 52;

  final String label;

  final TextEditingController controller;

  final String? hint;

  final String? error;

  final TextInputType? keyboardType;

  final bool obscure;

  final Widget? trailing;

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final String? error = this.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: AppText(label, type: AppTextTypeEnum.label)),
            ?trailing,
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: _height,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: AppTextTypeEnum.body
                .resolve(context)
                ?.copyWith(color: palette.onSurface),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextTypeEnum.body
                  .resolve(context)
                  ?.copyWith(color: palette.onSurfaceMuted),
              filled: true,
              fillColor: palette.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
              enabledBorder: _border(
                error == null ? palette.outlineStrong : palette.error,
              ),
              focusedBorder: _border(
                error == null ? palette.primary : palette.error,
              ),
            ),
          ),
        ),
        if (error != null) ...<Widget>[
          const SizedBox(height: AppSpacing.xs),
          AppText(
            error,
            type: AppTextTypeEnum.caption,
            color: palette.errorInk,
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadii.md),
    borderSide: BorderSide(color: color, width: AppSizes.borderStrong),
  );
}
