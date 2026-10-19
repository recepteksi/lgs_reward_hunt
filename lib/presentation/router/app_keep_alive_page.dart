import 'package:flutter/widgets.dart';

/// Keeps [child] built while its page of a `PageView` is off screen.
///
/// A `PageView` disposes the pages it is not showing; a child tab disposed is a
/// tab that loses its scroll position and reloads with a loading page when it
/// is swiped back to — the flash the tab shell exists to remove.
class AppKeepAlivePage extends StatefulWidget {
  const AppKeepAlivePage({required this.child, super.key});

  final Widget child;

  @override
  State<AppKeepAlivePage> createState() => _AppKeepAlivePageState();
}

class _AppKeepAlivePageState extends State<AppKeepAlivePage>
    with AutomaticKeepAliveClientMixin<AppKeepAlivePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
