import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/domain/account/entities/parent_entity.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/card/app_card.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The signed-in parent, as a compact card: initial, name, email, and how they
/// signed in.
///
/// [parent] supplies the first three; [via] is the sign-in method's word,
/// already localized, in the pill on the right. The initial sits on the primary
/// container rather than on a photo, because the parent has none and a grey
/// silhouette would say "missing" about something that was never asked for.
class ChildSetupParentCard extends StatelessWidget {
  const ChildSetupParentCard({
    required this.parent,
    required this.via,
    super.key,
  });

  static const double _badge = 40;

  final ParentEntity parent;

  final String via;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);

    return AppCard(
      radius: AppRadii.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: _badge,
            height: _badge,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: AppText(
              parent.initial,
              type: AppTextTypeEnum.title,
              weight: FontWeight.w900,
              color: palette.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppText(
                  parent.name,
                  type: AppTextTypeEnum.body,
                  weight: FontWeight.w800,
                  maxLines: ValueConstants.one,
                  overflow: TextOverflow.ellipsis,
                ),
                AppText(
                  parent.email,
                  type: AppTextTypeEnum.meta,
                  color: palette.onSurfaceMuted,
                  maxLines: ValueConstants.one,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            height: AppSizes.statusPill,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadii.round),
            ),
            child: AppText(
              via,
              type: AppTextTypeEnum.caption,
              weight: FontWeight.w800,
              color: palette.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
