part of 'appearance_cubit.dart';

/// What the shell is currently wearing.
///
/// One variant, and deliberately so. The other Cubits in this app are `sealed`
/// over several states because their screens can be waiting or broken; this one
/// cannot be either. There is always an answer — the stored settings, or the
/// defaults — so a loading state would be a state no widget could ever draw
/// anything useful for.
sealed class AppearanceState {
  const AppearanceState(this.settings);

  final AppearanceSettingsValueObject settings;
}

/// The settings the app is drawn with — the one thing appearance ever shows.
final class AppearanceReady extends AppearanceState {
  const AppearanceReady(super.settings);
}
