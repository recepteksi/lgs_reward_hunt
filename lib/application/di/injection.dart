import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lgs_reward_hunt/application/di/injection.config.dart';

/// The one container, and the only place any layer is allowed to look one up.
///
/// Everything else takes its dependencies through its constructor. A class that
/// reaches into [getIt] itself is a class no test can substitute anything into,
/// and the boundary the layers exist to draw stops being enforceable.
final GetIt getIt = GetIt.instance;

/// Wires the graph. Called once, from `main`, before the app runs.
///
/// The registrations are generated from the `@injectable` annotations rather
/// than hand-written, so adding a use case is one annotation instead of an edit
/// here that is easy to forget and impossible to notice.
@InjectableInit(asExtension: false)
Future<void> configureDependencies() async => init(getIt);
