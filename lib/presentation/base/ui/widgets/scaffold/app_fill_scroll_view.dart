import 'package:flutter/widgets.dart';

/// A body that fills the screen when it fits and scrolls when it does not.
///
/// A PIN page puts its heading at the top and its keypad at the bottom. With a
/// `Spacer` between them that is right on a tall phone and an overflow on a
/// short one — 139 pixels of it on a 360 × 640 screen. Here [child] is held to
/// at least the viewport's height, so a `Column` with
/// `MainAxisAlignment.spaceBetween` pushes its halves apart on a tall phone,
/// and scrolls as one piece on a short one.
class AppFillScrollView extends StatelessWidget {
  const AppFillScrollView({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: child,
            ),
          ),
    );
  }
}
