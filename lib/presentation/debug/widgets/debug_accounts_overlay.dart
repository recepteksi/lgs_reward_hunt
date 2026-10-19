import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_palette.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_radii.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/values/app_spacing.dart';

/// A see-through button over every screen of a dev build that opens the
/// backend's accounts: e-mail, password, PIN, link code and children.
///
/// It is for a tester who signed up an hour ago and cannot remember with what,
/// and for anyone who needs the demo parent's PIN without opening
/// `assets/mock/demo_household.json`. `main` hands [readAccounts] in only for
/// the dev flavor — a prod build never builds this widget — and reads it fresh
/// on every open, so an account made a minute ago is already listed. Each
/// account is its fields in display order; [currentMarker] is the field `main`
/// sets on the account signed in on this device.
///
/// It sits in `MaterialApp.builder`, above the navigator, so it opens as a
/// panel in its own stack rather than as a route — there is no navigator to
/// push onto from here, and a route would also land in the app's history.
/// Tapping a row copies its value, which is what a tester wants to do with a
/// password. Its words are English: like the ui-kit sheet, it speaks to the
/// people building the app, not to a student.
class DebugAccountsOverlay extends StatefulWidget {
  const DebugAccountsOverlay({
    required this.readAccounts,
    required this.child,
    super.key,
  });

  static const String currentMarker = 'signedIn';

  final List<Map<String, String>> Function() readAccounts;

  final Widget child;

  @override
  State<DebugAccountsOverlay> createState() => _DebugAccountsOverlayState();
}

/// Whether the panel is open, and the accounts it was opened with.
class _DebugAccountsOverlayState extends State<DebugAccountsOverlay> {
  static const double _fabBottom = 112;

  static const double _fabOpacity = 0.45;

  static const double _panelMaxHeightFactor = 0.7;

  static const double _border = 1;

  static const double _currentBorder = 2;

  static const double _rowGap = 2;

  List<Map<String, String>>? _accounts;

  void _toggle() => setState(
    () => _accounts = _accounts == null ? widget.readAccounts() : null,
  );

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = AppPalette.of(context);
    final List<Map<String, String>>? accounts = _accounts;

    return Stack(
      children: <Widget>[
        widget.child,
        if (accounts != null)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggle,
              child: ColoredBox(color: palette.scrim),
            ),
          ),
        if (accounts != null)
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: MediaQuery.paddingOf(context).top + AppSpacing.md,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.sizeOf(context).height * _panelMaxHeightFactor,
              ),
              child: Material(
                color: palette.surface,
                borderRadius: BorderRadius.circular(AppRadii.md),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: <Widget>[
                    for (final Map<String, String> account in accounts)
                      _account(context, palette, account),
                  ],
                ),
              ),
            ),
          ),
        Positioned(
          right: AppSpacing.md,
          bottom: MediaQuery.paddingOf(context).bottom + _fabBottom,
          child: Opacity(
            opacity: _fabOpacity,
            child: FloatingActionButton.small(
              heroTag: null,
              tooltip: null,
              backgroundColor: palette.onSurface,
              foregroundColor: palette.surface,
              onPressed: _toggle,
              child: Icon(accounts == null ? Icons.person_search : Icons.close),
            ),
          ),
        ),
      ],
    );
  }

  Widget _account(
    BuildContext context,
    AppPalette palette,
    Map<String, String> account,
  ) {
    final bool current = account.containsKey(
      DebugAccountsOverlay.currentMarker,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.sm),
        border: Border.all(
          color: current ? palette.primary : palette.outline,
          width: current ? _currentBorder : _border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (final MapEntry<String, String> field in account.entries)
            if (field.key != DebugAccountsOverlay.currentMarker)
              InkWell(
                onTap: () =>
                    Clipboard.setData(ClipboardData(text: field.value)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: _rowGap),
                  child: Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: '${field.key}: ',
                          style: TextStyle(color: palette.onSurfaceMuted),
                        ),
                        TextSpan(
                          text: field.value,
                          style: TextStyle(
                            color: palette.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
