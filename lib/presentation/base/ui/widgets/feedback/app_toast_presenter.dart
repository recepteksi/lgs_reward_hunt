import 'package:flutter/material.dart';
import 'package:lgs_reward_hunt/core/constants/value_constants.dart';
import 'package:lgs_reward_hunt/presentation/base/ui/widgets/feedback/app_toast.dart';

/// Shows an `AppToast` for a moment, the one way the app does it.
///
/// Material's snack bar does the timing, the queue and the safe-area inset;
/// this hands it the kit's toast as its whole face, with no ground or shadow
/// of its own, so every notice in the app looks and behaves the same. A new
/// toast replaces one still showing rather than queueing behind it — two
/// pieces of good news in a row should not wait for each other.
///
/// [show] takes the toast to present.
abstract final class AppToastPresenter {
  static void show(BuildContext context, AppToast toast) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: ValueConstants.zeroDouble,
          content: toast,
        ),
      );
  }
}
