import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

/// Settings every test in this package runs under.
///
/// A tap that lands on something other than the widget it names is a failure,
/// not a warning. The password page test once "tapped" a button that had
/// scrolled away and then failed on a missing navigation, with the real cause
/// buried in a warning above.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  WidgetController.hitTestWarningShouldBeFatal = true;
  await testMain();
}
