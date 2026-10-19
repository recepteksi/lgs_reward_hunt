import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_sizes.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/l10n/generated/app_localizations.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/buttons/app_icon_button.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/icon/app_icons.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/text/app_text_type_enum.dart';

/// The bar at the top of a page, and the only thing `AppScaffold.appBar` takes.
///
/// Material's `AppBar` does the work — the height, the status-bar colour, the
/// title's place — and `AppTheme` already gives it the page's ground with no
/// elevation. What this adds is the app's own parts in its slots: the back
/// arrow is `AppIconButton` with the design's chevron rather than Material's
/// `BackButton`, the title is an `AppText` role, and there is never an
/// implied leading widget, because an arrow Flutter adds on its own is one no
/// page decided to show.
///
/// [onBack] shows the back arrow and is what it does — usually a pop, sometimes
/// a step back inside the page, which is why the page says so rather than the
/// bar guessing. [title] is optional: setup pages carry their heading in the
/// body, at the size the design gives it. [actions] sit at the right edge.
///
/// [AppAppBar.overlay] is the bar that floats over a full-bleed page — the
/// map: no ground of its own, [start] on the left — given what the actions
/// leave, so a long name shrinks rather than pushing them off — and [actions]
/// on the right, each an island the page draws. Pair it with
/// `AppScaffold.extendBehindAppBar` so the page runs underneath.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    this.title,
    this.onBack,
    this.actions = const <Widget>[],
    super.key,
  }) : start = null;

  const AppAppBar.overlay({
    required Widget this.start,
    this.actions = const <Widget>[],
    super.key,
  }) : title = null,
       onBack = null;

  final Widget? start;

  final String? title;

  final VoidCallback? onBack;

  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final String? title = this.title;
    final VoidCallback? onBack = this.onBack;
    final Widget? start = this.start;

    if (start != null) {
      return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        titleSpacing: AppSpacing.lg,
        centerTitle: false,
        title: Row(
          children: <Widget>[
            Flexible(child: start),
            const SizedBox(width: AppSpacing.sm),
            const Spacer(),
            ...actions,
          ],
        ),
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: AppSizes.iconButton + AppSpacing.sm,
      leading: onBack == null
          ? null
          : Padding(
              padding: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
              child: Center(
                child: AppIconButton.plain(
                  icon: AppIcons.back,
                  semanticLabel: AppL10n.of(context).commonBack,
                  onPressed: onBack,
                ),
              ),
            ),
      title: title == null
          ? null
          : AppText(
              title,
              type: AppTextTypeEnum.title,
              weight: FontWeight.w900,
            ),
      actions: <Widget>[
        ...actions,
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }
}
