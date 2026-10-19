import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button_style.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_button_variant_enum.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icon.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// Every button in the app, in the six shapes the design system defines.
///
/// It is one widget with six named constructors rather than six widgets,
/// because they are one control: a screen that invents a seventh is the screen
/// where the primary action stops being obvious. Material's `FilledButton` is
/// not used for the two loud ones, because the thing that makes them look
/// pressable is not a shadow — it is a solid, unblurred edge sitting five
/// pixels below the face, and pressing moves the face down onto it. That is
/// motion Material's elevation model cannot express, and it is most of why this
/// app reads as a game rather than as a form.
///
/// [AppButton.filled] is the primary action, and there is one per screen.
/// [AppButton.reward] is the same weight in the currency colour and is used for
/// exactly one thing: spending points. [AppButton.tonal] is the quiet
/// affirmative, [AppButton.rewardTonal] its amber counterpart,
/// [AppButton.outlined] the refusal or the secondary, and [AppButton.text] the
/// way out of a screen — smaller, and the only one that does not sit on an
/// edge. [AppButton.errorOutlined] is the seventh and exists for one place: the
/// retry inside a failure card, whose ground is already the error container and
/// on which a primary-coloured outline would be the only thing in the card not
/// speaking about the failure.
///
/// A null [onPressed] disables the button, which flattens it to the neutral
/// fill: a disabled control that keeps its colour is one a child keeps tapping.
/// [icon] is optional and leads the label. [isExpanded] stretches the button to
/// the width it is given, which is how the primary action appears at the foot
/// of a sheet.
class AppButton extends StatefulWidget {
  const AppButton.filled({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    super.key,
  }) : _variant = AppButtonVariantEnum.filled;

  const AppButton.reward({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    super.key,
  }) : _variant = AppButtonVariantEnum.reward;

  const AppButton.tonal({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    super.key,
  }) : _variant = AppButtonVariantEnum.tonal;

  const AppButton.rewardTonal({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    super.key,
  }) : _variant = AppButtonVariantEnum.rewardTonal;

  const AppButton.outlined({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    super.key,
  }) : _variant = AppButtonVariantEnum.outlined;

  const AppButton.errorOutlined({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    super.key,
  }) : _variant = AppButtonVariantEnum.errorOutlined;

  const AppButton.text({
    required this.label,
    required this.onPressed,
    this.icon,
    this.isExpanded = false,
    super.key,
  }) : _variant = AppButtonVariantEnum.text;

  final String label;

  final VoidCallback? onPressed;

  final String? icon;

  final bool isExpanded;

  final AppButtonVariantEnum _variant;

  @override
  State<AppButton> createState() => _AppButtonState();
}

/// Holds whether the face is currently down.
///
/// The press is state rather than an animation controller because the design
/// moves the button in one step and back in one step; interpolating it would
/// add a wobble the design does not have.
class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final bool isEnabled = widget.onPressed != null;
    final AppButtonStyle skin = AppButtonStyle.resolve(
      widget._variant,
      palette,
      isEnabled: isEnabled,
    );
    final bool isDown = _isPressed && isEnabled;
    final double height = widget._variant == AppButtonVariantEnum.text
        ? AppSizes.minTapTarget
        : AppSizes.buttonHeight;
    final double radius = widget._variant == AppButtonVariantEnum.text
        ? AppRadii.sm
        : AppRadii.md;
    final double padding = widget._variant == AppButtonVariantEnum.text
        ? AppSizes.textButtonPadding
        : AppSizes.buttonPadding;
    final String? icon = widget.icon;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: widget.label,
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: isEnabled
            ? () => setState(() => _isPressed = false)
            : null,
        behavior: HitTestBehavior.opaque,
        child: Transform.translate(
          offset: Offset(
            ValueConstants.zeroDouble,
            isDown ? AppSizes.pressTravel : ValueConstants.zeroDouble,
          ),
          child: Container(
            height: height,
            width: widget.isExpanded ? double.infinity : null,
            padding: EdgeInsets.symmetric(horizontal: padding),
            decoration: BoxDecoration(
              color: skin.background,
              borderRadius: BorderRadius.circular(radius),
              border: skin.border,
              boxShadow: skin.shadows(isDown: isDown),
            ),
            child: Row(
              mainAxisSize: widget.isExpanded
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  AppIcon(
                    icon,
                    color: skin.foreground,
                    size: AppSizes.iconSize,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Flexible(
                  child: AppText(
                    widget.label,
                    type: widget._variant == AppButtonVariantEnum.text
                        ? AppTextTypeEnum.body
                        : AppTextTypeEnum.button,
                    color: skin.foreground,
                    weight: FontWeight.w900,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
